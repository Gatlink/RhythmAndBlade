using UnityEngine;
using System.Collections.Generic;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class Rail : MonoBehaviour
{
    public const float GIZMORADIUS = 0.1f;
    public static readonly Color IDLECOLOR = new Color(0.4f, 0.5f, 0.7f);
    public static readonly Color ACTIVECOLOR = new Color(0.5f, 0.8f, 1f);

    [HideInInspector]
    public List<Vector3> points;

    public void Reset()
    {
        points = new List<Vector3>();
        points.Add(new Vector2(-10, 0));
        points.Add(new Vector2(10, 0));
    }

#if UNITY_EDITOR
    static private Vector3 dragWorldStart;
    static private Vector2 dragMouseCurrent;
    static private Vector2 dragMouseStart;

    public void OnDrawGizmos()
    {
        if (Selection.activeTransform != transform)
            DrawHandles();
    }

    public void DrawHandles(bool editable = false)
    {
        Handles.color = IDLECOLOR;
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
                newPoints.Add(DrawPointHandle(cur) - transform.position);
            else
            {
                Handles.DrawSolidDisc(cur, Vector3.forward, GIZMORADIUS);
                newPoints.Add(points[i]);
            }
        }

        points.Clear();
        points.AddRange(newPoints);
    }

    private Vector3 DrawPointHandle(Vector3 position)
    {
        var id = GUIUtility.GetControlID(FocusType.Passive);
        var screenPosition = Handles.matrix.MultiplyPoint(position);
        var cachedMatrix = Handles.matrix;

        switch (Event.current.GetTypeForControl(id))
        {
        case EventType.MouseDown:
            if (HandleUtility.nearestControl == id && (Event.current.button == 0 || Event.current.button == 1))
            {
                GUIUtility.hotControl = id;

                dragMouseCurrent = dragMouseStart = Event.current.mousePosition;
                dragWorldStart = position;
                
                Event.current.Use();
                EditorGUIUtility.SetWantsMouseJumping(1);
            }
            break;

        case EventType.MouseUp:
            if (GUIUtility.hotControl == id && (Event.current.button == 0 || Event.current.button == 1))
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

                Debug.Log(position);
                Debug.Log(position2);

                position = position2;
                GUI.changed = true;
                Event.current.Use();
            }
            break;

        case EventType.Repaint:
            var currentColour = Handles.color;
            if (id == GUIUtility.hotControl)
                Handles.color = ACTIVECOLOR;

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

        return position;
    }
#endif
}