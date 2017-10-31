using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Actor : MonoBehaviour
{
	private const float MIN_SPEED = 0.001f;

	[Range(0f, 1f)]
	public float acceleration = 0.2f;
	public Vector2 maxSpeed;

	private Vector2 currentVelocity;

	public void Update()
	{
		var desiredVelocity = Vector2.zero;
		if (Input.GetKey(KeyCode.RightArrow))
			desiredVelocity.x = maxSpeed.x;
		else if (Input.GetKey(KeyCode.LeftArrow))
			desiredVelocity.x = -maxSpeed.x;

		currentVelocity = acceleration * desiredVelocity + (1 - acceleration) * currentVelocity;
		if (desiredVelocity.x == 0f && Mathf.Abs(currentVelocity.x) < MIN_SPEED)
			currentVelocity.x = 0f;

		transform.position = (Vector2) transform.position + currentVelocity * Time.deltaTime;
	}
}
