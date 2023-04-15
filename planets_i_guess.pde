
ArrayList<Body> bodies = new ArrayList<Body>();
boolean simulating = true;
boolean simulatePaths = true;
PVector referencePlanetOffset = new PVector(0, 0);
Body sun;
KeybindManager kbManager;
UI ui;

void setup()
{
  size(1000, 1000);
  frameRate(DESIRED_FRAMERATE + 10);
  colorMode(COLOR_MODE, 360);
  textAlign(CENTER, CENTER);
  textSize(14);

  // Set up UI
  kbManager = new KeybindManager();
  setupKeybinds();
  ui = new UI();

  // Set up simulation
  sun = createNewPlanet(0, 0,
    0, 0,
    0, 0,
    15, 1000,
    true, color(180, 360, 360), "Centauri A20");
  PlanetSelector.setSelectedPlanet(sun);
  PlanetSelector.setReferencedPlanet(sun);

  createRandomInitialPlanets(3);
}

void setupKeybinds()
{
  kbManager.addKeybind("ToggleSim", 's', "Toggle Sim", "S", () -> {
    simulating = !simulating;
  }
  );

  kbManager.addKeybind("TogglePaths", 'p', "Toggle Paths", "P", () -> {
    simulatePaths = !simulatePaths;
  }
  );

  kbManager.addKeybind("ToggleUI", 'i', "Toggle UI", "I", () -> {
    ui.toggle();
  }
  );

  kbManager.addKeybind("ResetReference", 'r', "Reset Reference", "R",
    () -> {
    referencePlanetOffset.add(PlanetSelector.getCurrentlyReferencedPlanet().position);
    PlanetSelector.setReferencedPlanet(sun);
  }
  );

  kbManager.addKeybind("ReferenceSelected", 't', "Reference Selected", "T",
    () -> {
    Body s = PlanetSelector.getCurrentlySelectedPlanet();
    if (s != null) {
      referencePlanetOffset.set(0, 0);
      PlanetSelector.setReferencedPlanet(s);
    }
  }
  );

  kbManager.addKeybind("DeletePlanet", DELETE, "Delete Planet", "DEL",
    () -> {
    deleteSelectedPlanet();
  }
  );

  kbManager.addKeybind("CycleMode", TAB, "Cycle Mode", "TAB", () -> {
    OnMouseClickModeEnumManager.cycleToNextMode();
  }
  );

  float planetVelocityChangeStep = 0.1;
  kbManager.addCodedKeybind("LeftVelocity", LEFT, "Move Velocity Left", "LEFT", () -> {
    Body b = PlanetSelector.getCurrentlySelectedPlanet();
    if(b == null)  
      return;
    b.velocity.add(-planetVelocityChangeStep, 0);
  }
  );

  kbManager.addCodedKeybind("RightVelocity", RIGHT, "Move Velocity Right", "RIGHT", () -> {
    Body b = PlanetSelector.getCurrentlySelectedPlanet();
    if(b == null)  
      return;
    b.velocity.add(planetVelocityChangeStep, 0);
  }
  );

  kbManager.addCodedKeybind("UPVelocity", UP, "Move Velocity UP", "UP", () -> {
    Body b = PlanetSelector.getCurrentlySelectedPlanet();
    if(b == null)  
      return;
    b.velocity.add(0, -planetVelocityChangeStep);
  }
  );

  kbManager.addCodedKeybind("DownVelocity", DOWN, "Move Velocity Down", "DOWN", () -> {
    Body b = PlanetSelector.getCurrentlySelectedPlanet();
    if(b == null)  
      return;
    b.velocity.add(0, planetVelocityChangeStep);
  }
  );
}

void renderGrid()
{
  PVector referencePosition = getGlobalReferencePosition();
  float cellSize = 100;
  strokeWeight(1);
  stroke(120, 0, 45);

  pushMatrix();
  translate(-referencePosition.x % cellSize, -referencePosition.y % cellSize);
  for (float i = -cellSize; i <= height; i += cellSize)
  {
    line(i, -i, i, i + height);
    line(-i, i, i + width, i);
  }

  popMatrix();
}

void renderSelectedPlanetUI()
{
  pushMatrix();
  translate(width / 2, height / 2); // Draw in the middle of the screen
  /********************************************************************************************************/
  // Draw Selected Planet data
  // - Marker
  Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();
  Body referencePlanet = PlanetSelector.getCurrentlyReferencedPlanet();
  PVector referencePosition = getGlobalReferencePosition();

  if (selectedPlanet != null)
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
  popMatrix();
}

void takeSimulationStep()
{
  if (simulating)
  {
    for (int i = 0; i < STEPS_PER_FRAME; i++)
    {
      calculateAttractions(bodies);
      for (Body b : bodies)
        b.updatePosition();
      resolveCollisions(bodies);
    }
  }
}

static void calculateAttractions(ArrayList<Body> bodies)
{
  for (int i = 0; i < bodies.size() - 1; i++)
  {
    for (int j = i + 1; j < bodies.size(); j++)
    {
      Body a = bodies.get(i);
      Body b = bodies.get(j);
      a.applyAcceleration(gravitationalAcceleration(a, b));
      b.applyAcceleration(gravitationalAcceleration(b, a));
    }
  }
}

void resolveCollisions(ArrayList<Body> bodies)
{
  for (int i = 0; i < bodies.size(); i++)
  {
    for (int j = i + 1; j < bodies.size(); j++)
    {
      Body a = bodies.get(i);
      Body b = bodies.get(j);
      float sumR = a.radius + b.radius;
      PVector dir = PVector.sub(b.position, a.position);
      float dist = dir.mag();
      if (sumR < dist)
        continue;

      float totalMomentum = PVector.add(a.calculateMomentum(), b.calculateMomentum()).mag();
      // Calculate new velocities
      PVector v1 = PVector.add(
        PVector.mult(a.velocity, (a.mass - b.mass) / (a.mass + b.mass)),
        PVector.mult(b.velocity, (2 * b.mass) / (a.mass + b.mass))
        );
      PVector v2 = PVector.add(
        PVector.mult(a.velocity, (2*a.mass) / (a.mass + b.mass)),
        PVector.mult(b.velocity, (b.mass - a.mass) / (a.mass + b.mass))
        );

      a.setVelocity(v1);
      b.setVelocity(v2);

      // Set new positions by offseting each by half of the distance in the relative direction
      float offsetTotal = dist - sumR;

      float offsetA = offsetTotal * (1 - a.mass / (a.mass + b.mass));
      float offsetB = offsetTotal * (1 - b.mass / (a.mass + b.mass));

      a.forceMovePosition(PVector.mult(dir, 1).setMag(offsetA));
      b.forceMovePosition(PVector.mult(dir, -1).setMag(offsetB));

      float totalMomentum2 = PVector.add(a.calculateMomentum(), b.calculateMomentum()).mag();
      println(a.name, "HAS COLLIDED WITH", b.name);
      println("\tMomentum1:", totalMomentum);
      println("\tMomentum2:", totalMomentum2, "(" + (totalMomentum == totalMomentum2) + ")");
    }
  }
}

void draw()
{
  background(20);
  PVector referencePosition = getGlobalReferencePosition();

  // calculate the paths prior to moving, this helps stabilise them visually as they are only a visual idea anyways
  if (simulatePaths)
    PathSimulator.simulatePaths(bodies, referencePosition, frameRate);

  takeSimulationStep();
  renderGrid();

  pushMatrix();
  translate(width / 2, height / 2);
  for (Body body : bodies)
    body.drawPath(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, false, simulatePaths, referencePosition);
  for (Body body : bodies)
    body.drawPlanet(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, false, simulatePaths, referencePosition);

  popMatrix();
  renderSelectedPlanetUI();
  ui.render();
}

Body createNewPlanet(float x, float y, float vx, float vy, float ax, float ay, float r, float g, boolean fixed, color c, String name)
{
  Body body = new Body(x, y, vx, vy, ax, ay, r, g, fixed, c, name);
  bodies.add(body);

  ui.planetListWindow.addNewPlanet(body);
  return body;
}

boolean deleteSelectedPlanet()
{
  Body body = PlanetSelector.getCurrentlySelectedPlanet();
  if (body != null)
  {
    bodies.remove(body);
    ui.planetListWindow.removeBodyFromList(body);
    PlanetSelector.setSelectedPlanet(null);
    return true;
  }
  return false;
}

PVector getGlobalReferencePosition()
{
  Body body = PlanetSelector.getCurrentlyReferencedPlanet();
  if (body == null)
    return referencePlanetOffset;
  return PVector.add(body.position, referencePlanetOffset);
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
  if (!validMousePosition(mouseX, mouseY) || ui.click(mouseX, mouseY))
    return;

  PVector referencePosition = getGlobalReferencePosition();
  PVector mousePosWithOffset = new PVector(mouseX, mouseY).sub(width / 2, height / 2).add(referencePosition);

  if (mouseButton == LEFT)
  {
    switch(OnMouseClickModeEnumManager.getMode())
    {
    case PLANET_CREATE_SELECT:
      // createOrSelectPlanetAtPosition returns null if it selected a planet, and a 'Body' if it created one
      Body b = createOrSelectPlanetAtPosition(mousePosWithOffset);
      if (b != null)
      {
        setBodyInOrbitAroundGreatestAttractor(b, bodies);
        simulating = false;
      }
      break;
    case PLANET_SET_REFERENCED:
      referencePlanetAtMousePosition(mousePosWithOffset);
      break;
    case NONE:
    default:
      break;
    }
  } else if (mouseButton == RIGHT)
    setSelectedPlanetVelocityTowardsMousePosition(mousePosWithOffset);
  else {
  }
}

void mouseDragged()
{
  if (!validMousePosition(mouseX, mouseY) || ui.mouseDragged(mouseX, mouseY))
    return;

  PVector referencePosition = getGlobalReferencePosition();
  PVector mousePosWithOffset = new PVector(mouseX, mouseY).sub(width / 2, height / 2).add(referencePosition);

  if (mouseButton == RIGHT)
    setSelectedPlanetVelocityTowardsMousePosition(mousePosWithOffset);
  else if (mouseButton == LEFT)
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
  if (key == CODED)
  {
    kbManager.activateCodedKeybind(keyCode);
  } else
  {
    kbManager.activateKeybind(key);
  }
}
