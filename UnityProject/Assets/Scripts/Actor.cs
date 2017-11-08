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

	[System.Serializable]
	public class JumpParameter
	{
		public float duration = 0.2f;
		public float verticalSpeed = 5f;
		public float horizontalSpeedFactor = 0.5f;
	}

	public bool ignoreCollisions;
	public float collisionRadius = 1f;
	public SpeedData horizontalMovement;
	[Space]
	public bool ignoreGravity;
	public Transform railConnector;
	public SpeedData falling;
	[Space]
	public JumpParameter jumpParameters;
	
	[HideInInspector]
	public Vector2 desiredVelocity = new Vector2();
	[HideInInspector]
	public Vector2 currentVelocity = new Vector2();

	private GamepadController controller;
	private ActorState currentState;


// PROPERTY

	public bool IsGrounded { get; private set; }


// UNITY MESSAGES

	public void Start()
	{
		if (railConnector == null)
			railConnector = transform;

		controller = new GamepadController(this);
		TransitionTo<StateNormal>();
	}

	public void Update()
	{
		Vector3 railProj;
		var hasProj = Rail.GetRailProjection(railConnector.position, out railProj);

		desiredVelocity.Set(0f, 0f);
		controller.Update();
		currentState.Update();

		currentVelocity.x = horizontalMovement.UpdateVelocity(currentVelocity.x, desiredVelocity.x);
		if (!ignoreGravity)
			currentVelocity.y = falling.UpdateVelocity(currentVelocity.y, falling.maxSpeed);

		transform.position = (Vector2) transform.position + currentVelocity * Time.deltaTime;

		CheckGround(hasProj, railProj);
		CheckCollisions();
	}

#if UNITY_EDITOR
	public void OnDrawGizmos()
	{
		Gizmos.color = Color.red;
		Gizmos.DrawWireSphere(transform.position, collisionRadius);
	}
#endif

// FSM

	public void TransitionTo<T>() where T : ActorState, new()
	{
		if (currentState != null)
			currentState.OnExit();
		
		currentState = new T();
		currentState.OnEnter(this);
	}


// UTILITY

	private void CheckGround(bool hasProj, Vector3 projection)
	{
		if (hasProj && projection.y > railConnector.position.y)
		{
			var delta = projection.y - railConnector.position.y;
			transform.position = transform.position + Vector3.up * delta;
			currentVelocity.y = 0f;
			IsGrounded = true;
		}
		else
			IsGrounded = false;
	}

	private void CheckCollisions()
	{
		if (ignoreCollisions)
			return;

		foreach (var wall in Rail.GetAllCollidingWalls(transform.position, collisionRadius))
		{
			var offset = 0f;
			if (transform.position.x > wall)
				offset = wall - (transform.position.x - collisionRadius);
			else
				offset = wall - (transform.position.x + collisionRadius);

			currentVelocity.x = 0f;
			transform.position += Vector3.right * offset;
		}
	}
}

public abstract class ActorState
{
	protected Actor actor;

	public virtual void OnEnter(Actor parent) { actor = parent; }
	public virtual void Update() {}
	public virtual void OnExit() {}
}

public class StateNormal : ActorState {}

public class StateJump : ActorState
{
	private float startTime;

	public override void OnEnter(Actor parent)
	{
		base.OnEnter(parent);

		if (!actor.IsGrounded)
		{
			actor.TransitionTo<StateNormal>();
			return;
		}

		actor.ignoreGravity = true;
		startTime = Time.time;
	}

	public override void Update()
	{
		actor.desiredVelocity.x *= actor.jumpParameters.horizontalSpeedFactor;
		actor.currentVelocity.y = actor.jumpParameters.verticalSpeed;

		if (Time.time >= startTime + actor.jumpParameters.duration)
			actor.TransitionTo<StateNormal>();
	}

	public override void OnExit()
	{
		actor.ignoreGravity = false;
	}
}