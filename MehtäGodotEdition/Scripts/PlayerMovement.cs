using Godot;
using System;

public partial class PlayerMovement : Node
{
	[Export] 
	public bool movementEnabled;
	[Export]
	public float speed;

	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
        Vector2 motion = new Vector2(0, 0);

        if (movementEnabled)
		{
			motion.X = Input.GetActionStrength("MoveRight") - Input.GetActionStrength("MoveLeft");
			motion.Y = Input.GetActionStrength("MoveDown") - Input.GetActionStrength("MoveUp");
		}

		CharacterBody2D parent = GetParent<CharacterBody2D>();
		parent.MoveAndCollide(motion.Normalized() * speed * (float)delta * 250);


		
	}
}
