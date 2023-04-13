
public float CalculateMass(float gravity, float radius)
{
  return gravity * radius * radius / G * MASS_SCALE_FACTOR;
}

public void setPlanetVelocityTowardsPosition(float x, float y, Body body)
{
  if (body == null || body.fixed)
    return;
  PVector dir = new PVector(x, y).sub(body.position);
  body.velocity.set(dir);
}

public void setPlanetPositionAt(float x, float y, Body body)
{
  if (body == null || body.fixed)
    return;
  body.position.set(x, y);
}


public Body randomBody()
{
  Body b = new Body(random(-1000f, 1000f), random(-1000, 1000),
    random(5, 10), random(5, 10),
    color(random(360), random(270), random(250, 360)));
  b.velocity.set(PVector.fromAngle(random(TWO_PI)).setMag(random(120, 300)));
  return b;
}

public boolean validMousePosition(float mx, float my)
{
  return mx >= 0 && mx < width && my >= 0 && my < height;
}
