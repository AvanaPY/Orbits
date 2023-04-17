ArrayList<Body> bodies = new ArrayList<Body>();
boolean simulating = true;
boolean simulatePaths = true;
PVector referencePlanetOffset = new PVector(0, 0);
Body sun;
UI ui;
KeybindManager kbManager;
CursorModeManager cursorModeManager;

float GRID_CELL_SIZE = 100;
float remPixelsX;
float remPixelsY;

PGraphics selectedPlanetOverlay;
void setup()
{
  size(1000, 1000, P2D);
  fullScreen(1);
  frameRate(DESIRED_FRAMERATE);
  colorMode(COLOR_MODE, 360);
  textAlign(CENTER, CENTER);
  textSize(14);
  noCursor();

  kbManager = new KeybindManager();
  cursorModeManager = new CursorModeManager();

  setupKeybinds();

  ui = new UI();
  remPixelsX = (width / 2) % GRID_CELL_SIZE;
  remPixelsY = (height / 2) % GRID_CELL_SIZE;

  sun = createNewPlanet(0, 0,
    0, 0,
    0, 0,
    15, 1000,
    true, color(180, 360, 360), "Centauri A20");
  PlanetSelector.setSelectedPlanet(sun);
  PlanetSelector.setReferencedPlanet(sun);
  //createRandomInitialPlanets(2, 5, 600, 250, 350, 1.4);
  
  selectedPlanetOverlay = createSelectedPlanetOverlay();
}

void draw()
{
  DYNAMIC_PATHS = !DYNAMIC_PATHS && frameCount > 300;

  background(10);
  PVector referencePosition = getGlobalReferencePosition();


  takeSimulationStep();
  // calculate the paths prior to moving, this helps stabilise them visually as they are only a visual idea anyways
  if (simulatePaths)
    PathSimulator.simulatePaths(bodies, referencePosition, frameRate);

  renderGrid();

  pushMatrix();
  translate(width / 2, height / 2);
  if (simulatePaths)
    for (Body body : bodies)
      body.drawPath(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, referencePosition);

  for (Body body : bodies)
    body.drawPlanet(PlanetSelector.selectedPlanet == body, PlanetSelector.referencePlanet == body, referencePosition);

  popMatrix();

  renderSelectedPlanetUI();
  ui.render();
  // Render a cursor
  switch(cursorModeManager.getCursorMode())
  {
  case CIRCLE:
    noCursor();
    float r = 20;
    noFill();
    stroke(cursorModeManager.getCursorColor());
    circle(mouseX, mouseY, 2 * r);
    strokeWeight(3);
    point(mouseX, mouseY);
    break;
  case ARROW:
    cursor(ARROW);
    break;
  case CROSS:
    cursor(CROSS);
    break;
  case HAND:
    cursor(HAND);
    break;
  case MOVE:
    cursor(MOVE);
    break;
  case TEXT:
    cursor(TEXT);
    break;
  case WAIT:
    cursor(WAIT);
    break;
  default:
    break;
  }
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

  kbManager.addKeybind("DeselectSelected", 'd', "Deselect", "D",
    () -> {
    USER_ACTION_DeselectSelectedPlanet();
  }
  );

  kbManager.addKeybind("ResetReference", 'r', "Reset Reference", "R",
    () -> {
    USER_ACTION_ResetReferenceOffset();
  }
  );

  kbManager.addKeybind("ReferenceSelected", 't', "Reference Selected", "T",
    () -> {
    USER_ACTION_SetSelectedAsReference();
  }
  );

  kbManager.addKeybind("DeletePlanet", DELETE, "Delete Planet", "DEL",
    () -> {
    deleteSelectedPlanet();
  }
  );

  kbManager.addKeybind("CycleMode", TAB, "Cycle Mode", "TAB", () -> {
    USER_ACTION_CycleNextClickMode();
  }
  );

  float planetVelocityChangeStep = 0.1;
  kbManager.addCodedKeybind("LeftVelocity", LEFT, "Move Velocity Left", "LEFT", () -> {
    USER_ACTION_ChangeSelectedPlanetVelocity(-planetVelocityChangeStep, 0);
  }
  );

  kbManager.addCodedKeybind("RightVelocity", RIGHT, "Move Velocity Right", "RIGHT", () -> {
    USER_ACTION_ChangeSelectedPlanetVelocity(planetVelocityChangeStep, 0);
  }
  );

  kbManager.addCodedKeybind("UPVelocity", UP, "Move Velocity UP", "UP", () -> {
    USER_ACTION_ChangeSelectedPlanetVelocity(0, -planetVelocityChangeStep);
  }
  );

  kbManager.addCodedKeybind("DownVelocity", DOWN, "Move Velocity Down", "DOWN", () -> {
    USER_ACTION_ChangeSelectedPlanetVelocity(0, planetVelocityChangeStep);
  }
  );
}

void renderGrid()
{
  PVector referencePosition = getGlobalReferencePosition();
  float offsetX = referencePosition.x % GRID_CELL_SIZE + GRID_CELL_SIZE - remPixelsX;
  float offsetY = referencePosition.y % GRID_CELL_SIZE + GRID_CELL_SIZE - remPixelsY;

  pushMatrix();
  translate(-offsetX, -offsetY);

  strokeWeight(1);
  stroke(120, 0, 45);
  for (float i = 0; i <= width + GRID_CELL_SIZE; i += GRID_CELL_SIZE)
    line(i, -GRID_CELL_SIZE, i, height + GRID_CELL_SIZE);

  for (float i = 0; i <= height + GRID_CELL_SIZE; i += GRID_CELL_SIZE)
    line(-GRID_CELL_SIZE, i, width + 2 * GRID_CELL_SIZE, i);

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
    float baseMarkerLength = 20;
    float markerLength = baseMarkerLength;// * map((sin(frameCount / 30f) + 1), -1, 1, 0.4, 1);

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
    image(selectedPlanetOverlay, - selectedPlanetOverlay.width / 2, - selectedPlanetOverlay.height / 2);
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
    }
  }
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
    OnMouseClickModeEnum e = OnMouseClickModeEnumManager.getMode();
    switch(e)
    {
    case PLANET_CREATE_SELECT:
      // createOrSelectPlanetAtPosition returns null if it selected a planet, and a 'Body' if it created one
      Body b = createOrSelectPlanetAtPosition(mousePosWithOffset);
      if (b != null)
      {
        Body refPlanet = PlanetSelector.getCurrentlyReferencedPlanet();
        if (refPlanet != null)
          setBodyInOrbitAroundBody(b, refPlanet, 1);
        else
          setBodyInOrbitAroundGreatestAttractor(b, bodies);

        simulating = false;
      }
      break;
    case PLANET_CREATE_MOON:
      Body refPlanet = PlanetSelector.getCurrentlyReferencedPlanet();
      if (refPlanet == null)
        break;
      Body moon = createNewRandomPlanetAtPosition(mousePosWithOffset);
      moon.setRadius(PLANET_MOON_RADIUS);
      moon.setGravity(PLANET_MOON_GRAVITY);
      setBodyInOrbitAroundBody(moon, refPlanet, 1);
      PlanetSelector.setSelectedPlanet(moon);
      break;
    case NONE:
    default:
      println("WARING: Encountered unaccounted-for OnMouseClickModeEnum: ", e);
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
