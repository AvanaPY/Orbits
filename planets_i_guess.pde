
ArrayList<Body> bodies = new ArrayList<Body>();
boolean simulating = false;
boolean simulatePaths = true;
PVector referencePlanetOffset = new PVector(0, 0);
Body sun;
KeybindManager kbManager;
UI ui;

void setup()
{
  size(1000, 1000);
  frameRate(60);
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
      for (Body body : bodies)
        body.attractExceptSelf(bodies);
      for (Body body : bodies)
        body.updatePosition();
    }
  }
  // Simulate the paths
  PVector referencePosition = getGlobalReferencePosition();
  if (simulatePaths)
    PathSimulator.simulatePaths(bodies, referencePosition);
}

void draw()
{
  background(20);
  PVector referencePosition = getGlobalReferencePosition();

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
      createOrSelectPlanetAtPosition(mousePosWithOffset);
      simulating = false;
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
  kbManager.activateKeybind(key);
}
