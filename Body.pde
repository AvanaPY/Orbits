public class Body
{
  private color c;
  private String name;

  private PVector position;
  private PVector velocity;
  private PVector acceleration;
  private PVector prevAcceleration;
  private float radius   = 0;
  private float mass     = 0;
  private float gravity  = 0;

  public SimulatedPathInformation pathInformation;
  private boolean fixed;

  public Body(float x, float y,
    float vx, float vy,
    float ax, float ay,
    float r, float g,
    boolean fixed, color col, String name)
  {
    position = new PVector(x, y);
    velocity = new PVector(vx, vy);
    acceleration = new PVector(ax, ay);
    prevAcceleration = new PVector(ax, ay);

    setColor(color(120, 360, 120));
    radius = r;
    gravity = g;
    recalculateMass();

    this.fixed = fixed;
    this.c = col;
    this.name = name;

    pathInformation = new SimulatedPathInformation();
  }

  public Body(float x, float y, float r, float g, color col)
  {
    this(x, y, 0, 0, 0, 0, r, g, false, col, getRandomPlanetName());
  }


  public Body(float x, float y, float r, float g, color col, String name)
  {
    this(x, y, 0, 0, 0, 0, r, g, false, col, name);
  }

  public Body(PVector p, PVector v, PVector a, float r, float g, boolean fixed, color c, String name)
  {
    this(p.x, p.y, v.x, v.y, a.x, a.y, r, g, fixed, c, name);
  }

  public Body clone()
  {
    Body body = new Body(position, velocity, acceleration, radius, gravity, fixed, c, name);
    return body;
  }

  public String toString()
  {
    return name;
  }

  public void setFixed(boolean state)
  {
    fixed = state;
  }

  public void setColor(color _c)
  {
    c = _c;
  }

  public void setRadius(float r) {
    radius = max(min(r, PLANET_MAXIMUM_RADIUS), PLANET_MINIMUM_RADIUS);
    recalculateMass();
  }

  public void setGravity(float g) {
    gravity = max(min(g, PLANET_MAXIMUM_GRAVITY), PLANET_MINIMUM_GRAVITY);
    recalculateMass();
  }

  private void recalculateMass()
  {
    mass = CalculateMass(gravity, radius);
  }

  public void resetAcceleration()
  {
    acceleration.set(0, 0);
  }

  public void attractExceptSelf(Iterable<Body> bodies)
  {
    resetAcceleration();
    for (Body body : bodies)
    {
      if (body == this)
        continue;

      PVector direction = PVector.sub(body.position, position);
      float force = gravitationalForce(this, body);
      float acc = force / this.mass;
      direction.setMag(acc);
      acceleration.add(direction);
    }
  }

  public void updatePosition()
  {
    if (fixed)
      return;
    velocity.add(acceleration);
    position.add(PVector.mult(velocity, TIME_STEP_SIZE));
    prevAcceleration.set(acceleration);
  }

  public void drawPath(boolean isSelected, boolean isReference, boolean drawMass, boolean drawPath, PVector referencePosition)
  {
    pushMatrix();
    translate(-referencePosition.x, -referencePosition.y);
    if (drawPath && !isReference)
    {
      if (pathInformation.path.size() > 0)
      {
        beginShape();
        noFill();
        stroke(hue(c), saturation(c), 120);
        strokeWeight(2);
        for (PVector p : pathInformation.path)
          vertex(p.x, p.y);
        endShape();

        if (pathInformation.willCollide)
        {
          fill(0, 360, 120);
          stroke(0, 360, 250);
          PVector lastPosition = pathInformation.path.get(pathInformation.path.size() - 1);
          circle(lastPosition.x, lastPosition.y, 2 * radius);
        }
      }
    }
    popMatrix();
  }

  public void drawPlanet(boolean isSelected, boolean isReference, boolean drawMass, boolean drawPath, PVector referencePosition)
  {
    // The path is evaluated in absolute positions so we draw it before translating to our position
    // but we still translate to the reference position
    pushMatrix();
    translate(position.x-referencePosition.x, position.y-referencePosition.y);

    noStroke();
    fill(c);
    circle(0, 0, 2 * radius);

    if (isSelected && !isReference)
    {
      strokeWeight(1);
      stroke(90, 360, 200);
      line(0, 0, velocity.x, velocity.y);
      strokeWeight(3);
      point(velocity.x, velocity.y);
    }

    popMatrix();
  }
}
