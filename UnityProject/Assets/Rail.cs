using UnityEngine;
using System.Linq;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class Rail : MonoBehaviour
{
    public const float GIZMORADIUS = 0.1f;
    public static readonly Color IDLECOLOR = new Color(0.4f, 0.4f, 0.5f);
    public static readonly Color ACTIVECOLOR = new Color(0.4f, 0.5f, 0.7f);
    public static readonly Color SELECTEDCOLOR = new Color(0.5f, 0.8f, 1f);
    public static readonly Color NEWCOLOR = new Color(0.5f, 0.8f, 1f, 0.5f);

    [HideInInspector, SerializeField]
    public List<Vector3> points;

    public void Reset()
    {
        if (points == null)
            points = new List<Vector3>();
        
        points.Clear();
        points.Add(new Vector2(-1, 0));
        points.Add(new Vector2(1, 0));
    }

    public bool GetProjection(int idx, Vector3 pos, out Vector3 proj)
    {
        proj = Vector3.negativeInfinity;
        if (idx > points.Count - 1)
            return false;

        var prev = points[idx];
        var next = points[idx + 1];

        if ((prev.x <= pos.x && next.x >= pos.x)
            || (prev.x >= pos.x && next.x <= pos.x))
        {
            var a = (next.y - prev.y) / (next.x - prev.x);
            var b = next.y - a * next.x;
            proj = new Vector3(pos.x, a * pos.x + b, 0f);
            return true;
        }

        return false;
    }

    public void GetPreviousAndNextPoint(Vector3 pos, out int prev, out int next)
    {
        prev = next = -1;
        if (points.Count == 0)
            return;
        
        if (points.Count == 1)
        {
            prev = next = 0;
            return;
        }

        var pts = new Dictionary<int, float>();
        for(var i = 0; i < points.Count - 1; ++i)
        {
            Vector3 proj;
            if (GetProjection(i, pos, out proj))
                pts.Add(i, Vector2.Distance(proj, pos));
        }

        if (pts.Count <= 0)
            return;

        prev = pts.OrderBy(kvp => kvp.Value).FirstOrDefault().Key;
        if (prev >= 0 && prev < points.Count - 1)
            next = prev + 1;
    }

    public bool GetClosestPointOnRail(Vector3 pos, out Vector3 projection)
    {
        projection = Vector3.negativeInfinity;
        if (points.Count == 0)
            return false;
        
        if (points.Count == 1)
        {
            projection = points[0];
            return true;
        }

        var pts = new List<Vector3>();
        for(var i = 0; i < points.Count - 1; ++i)
        {
            Vector3 proj;
            if (GetProjection(i, pos, out proj))
                pts.Add(proj);
        }

        var lastSqrDistance = float.MaxValue;
        var result = false;
        foreach (var point in pts)
        {
            var currentSqrDistance = Vector2.Distance(point, pos);
            if (currentSqrDistance < lastSqrDistance)
            {
                projection = point;
                lastSqrDistance = currentSqrDistance;
                result = true;
            }
        }

        return result;
    }

#if UNITY_EDITOR
    private const KeyCode ADDKEY = KeyCode.LeftControl;
    private const KeyCode DELKEY = KeyCode.Delete;

    private static Vector3 dragWorldStart;
    private static Vector2 dragMouseCurrent;
    private static Vector2 dragMouseStart;
    private static bool addKeyDown;

    public void OnDrawGizmos()
    {
        if (Selection.activeTransform != transform)
            DrawHandles();
    }

    public void DrawHandles(bool editable = false)
    {
        Handles.color = Selection.activeTransform == transform ? ACTIVECOLOR : IDLECOLOR;
        var newPoints = new List<Vector3>();
        for (var i = 0; i < points.Count; ++i)
        {
            var cur = transform.position + points[i];

            if (i + 1 < points.Count)
            {
                var next = transform.position + points[i + 1];
                Handles.DrawLine(cur, next);
            }
            
            if (editable)
            {
                if (DrawPointHandle(ref cur))
                    newPoints.Add(cur);
            }
            else
            {
                Handles.DrawSolidDisc(cur, Vector3.forward, GIZMORADIUS);
                newPoints.Add(points[i]);
            }
        }

        // Display new Point
        if (editable)
        {
            int newIndex;
            var newPoint = DisplayNewPoint(out newIndex);
            if (newIndex != -1)
            {
                newPoints.Insert(newIndex, newPoint);
                Undo.RecordObject(this, "Add new point");
            }
        }

        points.Clear();
        points.AddRange(newPoints);
    }

    private Vector3 DisplayNewPoint(out int newIndex)
    {
        newIndex = -1;

        var mousePosition = Event.current.mousePosition;
        mousePosition.y = Camera.current.pixelHeight - mousePosition.y;
        
        var position = Handles.inverseMatrix.MultiplyPoint(Camera.current.ScreenToWorldPoint(mousePosition));
        position.z = 0f;
        
        var prev = 0;
        var next = 0;
        if (addKeyDown)
        {
            GetPreviousAndNextPoint(position, out prev, out next);
            if ((prev == -1 || next == -1) && points.Count > 1)
                prev = Vector2.Distance(points[0], position) > Vector2.Distance(points[points.Count - 1], position) ? points.Count - 1 : 0;

            if (prev == -1)
                prev = 0;
        }

        switch (Event.current.type)
        {
        case EventType.KeyDown:
            if (Event.current.keyCode == ADDKEY)
                addKeyDown = true;
            break;

        case EventType.KeyUp:
            if (Event.current.keyCode == ADDKEY)
                addKeyDown = false;
            break;

        case EventType.Repaint:
            if (addKeyDown)
            {
                Handles.color = NEWCOLOR;
                Handles.DrawSolidDisc(position, Vector3.forward, GIZMORADIUS);

                var point = points[prev];
                Handles.DrawLine(point, position);

                if (next != -1)
                {
                    point = points[next];
                    Handles.DrawLine(point, position);
                }
                HandleUtility.Repaint();
            }
            break;

        case EventType.MouseDown:
            if (addKeyDown && Event.current.button == 0)
            {
                newIndex = prev > 0 ? prev + 1 : prev;
                Event.current.Use();
                return position;
            }
            break;
        }

        return Vector3.zero;
    }

    private bool DrawPointHandle(ref Vector3 position)
    {
        var id = GUIUtility.GetControlID(FocusType.Passive);
        var screenPosition = Handles.matrix.MultiplyPoint(position);
        var cachedMatrix = Handles.matrix;

        switch (Event.current.GetTypeForControl(id))
        {
        case EventType.MouseDown:
            if (Event.current.button != 0)
                break;
            
            if (HandleUtility.nearestControl == id)
            {
                GUIUtility.hotControl = id;

                dragMouseCurrent = dragMouseStart = Event.current.mousePosition;
                dragWorldStart = position;
                
                Event.current.Use();
                EditorGUIUtility.SetWantsMouseJumping(1);
            }
            break;

        case EventType.MouseUp:
            if (Event.current.button != 0)
                    break;
            
            if (GUIUtility.hotControl == id && Event.current.button == 0)
            {
                GUIUtility.hotControl = 0;
                Event.current.Use();
                EditorGUIUtility.SetWantsMouseJumping(0);
            }
            break;

        case EventType.MouseDrag:
            if (GUIUtility.hotControl == id)
            {
                dragMouseCurrent += new Vector2(Event.current.delta.x, -Event.current.delta.y);

                var position2 = Camera.current.WorldToScreenPoint(Handles.matrix.MultiplyPoint(dragWorldStart)) + (Vector3) (dragMouseCurrent - dragMouseStart);
                position2 = Handles.matrix.inverse.MultiplyPoint(Camera.current.ScreenToWorldPoint(position2));

                position = position2 - transform.position;
                GUI.changed = true;
                Event.current.Use();
                Undo.RecordObject(this, "Moved points");
            }
            break;

        case EventType.KeyDown:
            if (GUIUtility.hotControl == id && Event.current.keyCode == DELKEY)
            {
                Event.current.Use();
                Undo.RecordObject(this, "Delete point");
                return false;
            }
            break;

        case EventType.Repaint:
            var currentColour = Handles.color;
            if (id == GUIUtility.hotControl)
                Handles.color = SELECTEDCOLOR;

            Handles.matrix = Matrix4x4.identity;
            Handles.DrawSolidDisc(position, Vector3.forward, GIZMORADIUS);
            Handles.matrix = cachedMatrix;

            Handles.color = currentColour;
            break;

        case EventType.Layout:
            Handles.matrix = Matrix4x4.identity;
            HandleUtility.AddControl(id, HandleUtility.DistanceToCircle(screenPosition, GIZMORADIUS));
            Handles.matrix = cachedMatrix;
            break;
        }

        return true;
    }
#endif
}