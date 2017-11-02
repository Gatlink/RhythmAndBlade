using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Actor : MonoBehaviour
{
	[System.Serializable]
	public class SpeedData
	{
		private const float MIN_SPEED = 0.001f;

		[Range(0f, 1f)]
		public float acceleration = 0.2f;
		public float maxSpeed = 4f;

		public float UpdateVelocity(float oldSpeed, float desiredSpeed)
		{
			var current = acceleration * desiredSpeed + (1 - acceleration) * oldSpeed;
			if (current == 0f && Mathf.Abs(current) < MIN_SPEED)
				current = 0f;

			return current;
		}
	}

	public Transform railConnector;
	public SpeedData horizontalMovement;
	[Space]
	public bool applyGravity = true;
	public SpeedData falling;

	private Vector2 currentVelocity;

	public void Start()
	{
		if (railConnector == null)
			railConnector = transform;
	}

	public void Update()
	{
		Vector3 railProj;
		var hasProj = Rail.GetRailProjection(railConnector.position, out railProj);

		var desiredVelocity = Vector2.zero;
		currentVelocity.x = horizontalMovement.UpdateVelocity(currentVelocity.x, desiredVelocity.x);
		currentVelocity.y = applyGravity ? falling.UpdateVelocity(currentVelocity.y, falling.maxSpeed) : 0f;

		transform.position = (Vector2) transform.position + currentVelocity * Time.deltaTime;

		CheckGround(hasProj, railProj);
	}

	private void CheckGround(bool hasProj, Vector3 projection)
	{
		if (hasProj && projection.y > railConnector.position.y)
		{
			var delta = projection.y - railConnector.position.y;
			transform.position = transform.position + Vector3.up * delta;
			currentVelocity.y = 0f;
		}
	}
}
