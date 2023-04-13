
ArrayList<Body> bodies = new ArrayList<Body>();
boolean simulating = false;
boolean simulatePaths = true;
PlanetInfoWindow planetInfoWindow;
PVector referencePlanetOffset = new PVector(0, 0);

Body sun;


void setup()
{
  size(1000, 1000);
  frameRate(60);
  colorMode(HSB, 360);
  textAlign(CENTER, CENTER);
  textSize(14);

  sun = new Body(0, 0,
    0, 0,
    0, 0,
    20, 1000,
    false, color(180, 360, 360), "Centauri A20");

  PlanetSelector.setSelectedPlanet(sun);
  PlanetSelector.setReferencedPlanet(sun);
  sun.setFixed(false);
  bodies.add(sun);

  planetInfoWindow = new PlanetInfoWindow(new PVector(width - 300, 0), new PVector(300, 300));
}

void draw()
{
  background(20);

  PVector referencePosition = getGlobalReferencePosition();

  /********************************************************************************************************/
  // Simulate the paths
  if (simulatePaths)
    PathSimulator.simulatePaths(bodies, referencePosition);

  /********************************************************************************************************/
  // Update the planets
  if (simulating)
  {
    for (int i = 0; i < STEPS_PER_FRAME; i++)
    {
      for (Body body : bodies)
        body.attractExceptSelf(bodies);
      for (Body body : bodies)
        body.updatePosition();
    }
  }

  /********************************************************************************************************/
  // Draw in order:
  //  - Paths
  //  - Bodies

  pushMatrix();
  translate(width / 2, height / 2);

  for (Body body : bodies)
    body.drawPath(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, false, simulatePaths, referencePosition);
  for (Body body : bodies)
    body.drawPlanet(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, false, simulatePaths, referencePosition);

  /********************************************************************************************************/
  // Draw Selected Planet data
  // - Marker
  Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();
  Body referencePlanet = PlanetSelector.getCurrentlyReferencedPlanet();

  if (selectedPlanet!= null)
  {

    PVector p = PVector.sub(selectedPlanet.position, referencePosition);
    float r = max(selectedPlanet.radius * 1.2, 10);
    float angle = TWO_PI * (frameCount / 600f);
    float markerLength = 20 * map((sin(frameCount / 30f) + 1), -1, 1, 0.2, 1);

    // Draw reference planet's vel
    if (referencePlanet != null)
    {
      PVector relativeVelocity = PVector.sub(selectedPlanet.velocity, referencePlanet.velocity);

      // Relative velocity between Selected and Reference planet
      stroke(0, 360, 360);
      line(p.x, p.y, p.x + relativeVelocity.x, p.y + relativeVelocity.y);

      // Reference planet's relative
      stroke(180, 360, 360);
      pushMatrix();
      translate(-referencePlanetOffset.x, -referencePlanetOffset.y);
      line(0, 0, referencePlanet.velocity.x, referencePlanet.velocity.y);
      popMatrix();
    }

    // Draw selected planet marker
    stroke(45, 360, 360);
    strokeWeight(1);
    pushMatrix();
    translate(p.x, p.y);
    rotate(angle);
    line(0 - r, 0, 0 - r - markerLength, 0);
    line(0 + r, 0, 0 + r + markerLength, 0);
    line(0, 0 - r, 0, 0 - r - markerLength);
    line(0, 0 + r, 0, 0 + r + markerLength);
    popMatrix();
  }
  /********************************************************************************************************/
  popMatrix();

  // - Info Window (UI)
  if (selectedPlanet!= null)
    planetInfoWindow.DrawPlanetInfoWindow();
}

PVector getGlobalReferencePosition()
{
  if (PlanetSelector.referencePlanet == null)
    return referencePlanetOffset;
  return PVector.add(PlanetSelector.referencePlanet.position, referencePlanetOffset);
  //return PlanetSelector.referencePlanet == null ? referencePlanetOffset : PlanetSelector.referencePlanet.position;
}

void moveGlobalCameraOffset(float offsetX, float offsetY)
{
  referencePlanetOffset.add(offsetX, offsetY);
}

void setGlobalCameraOffset(float x, float y)
{
  referencePlanetOffset.set(x, y);
}

void mousePressed()
{
  if (!validMousePosition(mouseX, mouseY))
    return;
  PVector referencePosition = getGlobalReferencePosition();
  PVector mousePosWithOffset = new PVector(mouseX, mouseY).sub(width / 2, height / 2).add(referencePosition);

  if (planetInfoWindow.positionInsideWindow(mouseX, mouseY))
  {
    planetInfoWindow.click(mouseX, mouseY);
  } else if (mouseButton == LEFT)
  {

    boolean bSelectedPlanetOnClick = PlanetSelector.selectPlanetAt(mousePosWithOffset.x, mousePosWithOffset.y, bodies, 1.2);
    if (bSelectedPlanetOnClick)
      return;

    float x = mousePosWithOffset.x, y = mousePosWithOffset.y;
    float vx = 0, vy = 0;
    float ax = 0, ay = 0;
    float r = 5f;
    float g = 10f;
    color c = getRandomColor(0, 360, 360, 360, 270, 360);
    String name = getRandomPlanetName();

    Body body = new Body(x, y, vx, vy, ax, ay, r, g, false, c, name);
    bodies.add(body);
    PlanetSelector.setSelectedPlanet(body);
    simulating = false;
  } else if (mouseButton == RIGHT)
  {
    if (PlanetSelector.selectedPlanet != null)
    {
      setPlanetVelocityTowardsPosition(mousePosWithOffset.x, mousePosWithOffset.y, PlanetSelector.selectedPlanet);
    }
  } else {
    Body previousReference = PlanetSelector.referencePlanet;
    PlanetSelector.setReferencePlanetAt(mousePosWithOffset.x, mousePosWithOffset.y, bodies, 1.2);
    if (PlanetSelector.referencePlanet == null && previousReference != null)
    {
      PlanetSelector.setReferencedPlanet(previousReference);
    } else
    {
      setGlobalCameraOffset(0, 0);

      //setGlobalCameraOffset(previousReference.position.x, previousReference.position.y);
    }
  }
}

void mouseDragged()
{
  if (!validMousePosition(mouseX, mouseY))
    return;
  PVector referencePosition = getGlobalReferencePosition();
  PVector mousePosWithOffset = new PVector(mouseX, mouseY).sub(width / 2, height / 2).add(referencePosition);

  // If our mouse is inside the window and it is active, return
  if (planetInfoWindow.positionInsideWindow(mouseX, mouseY) && planetInfoWindow.active())
    return;

  if (mouseButton == RIGHT)
  {
    if (PlanetSelector.selectedPlanet != null)
    {
      setPlanetVelocityTowardsPosition(mousePosWithOffset.x, mousePosWithOffset.y, PlanetSelector.selectedPlanet);
    }
  } else if (mouseButton == LEFT)
  {
    if (PlanetSelector.selectedPlanet != null)
    {
      setPlanetPositionAt(mousePosWithOffset.x, mousePosWithOffset.y, PlanetSelector.selectedPlanet);
    }
  } else
  {
    moveGlobalCameraOffset(pmouseX - mouseX, pmouseY - mouseY);
  }
}

void keyPressed()
{
  if (key == 's')
  {
    simulating = !simulating;
  } else if (key == 'p')
  {
    simulatePaths = !simulatePaths;
  } else if (key == 'i')
  {
    planetInfoWindow.toggle();
  } else if (key == DELETE)
  {
    if (PlanetSelector.selectedPlanet != null)
    {
      bodies.remove(PlanetSelector.selectedPlanet);
      PlanetSelector.setSelectedPlanet(null);
    }
  }
}
