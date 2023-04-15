public float CalculateMass(float gravity, float radius)
{
  return gravity * radius * radius / G * M; // M is a mass constant found in 'consts', it helps with scaling the mass of planets so you don't have to make massive vectors to make orbits close to the sun
}

public static float gravitationalForce(Body a, Body b)
{
  return G * a.mass * b.mass / PVector.sub(a.position, b.position).magSq();
}

static PVector gravitationalAcceleration(Body a, Body b)
{
  PVector d = PVector.sub(b.position, a.position);
  d.setMag(G * b.mass / d.magSq());
  return d;
}

public void setPlanetPositionAt(float x, float y, Body body)
{
  if (body == null || body.fixed)
    return;
  body.position.set(x, y);
}

public boolean validMousePosition(float mx, float my)
{
  return mx >= 0 && mx < width && my >= 0 && my < height;
}

public color getRandomColor(float minHue, float maxHue, float minSat, float maxSat, float minB, float maxB)
{
  return color(random(minHue, maxHue), random(minSat, maxSat), random(minB, maxB));
}

public String getRandomPlanetName()
{
  String[] planetNames = {
    "Pithivis",
    "Caccuirilia",
    "Nogrurn",
    "Ilmapus",
    "Rugawa",
    "Meotania",
    "Stroacury",
    "Chimuvis",
    "Murn 6C1",
    "Cov ZCIE",
    "Zecrutis",
    "Gucrahines",
    "Nothuna",
    "Anzeshan",
    "Vaegawa",
    "Vuliv",
    "Brochitov",
    "Bichenus",
    "Meron",
    "Gilles XHW",
    "Gilnaotera",
    "Alvaturn",
    "Gastragua",
    "Olvagua",
    "Tubos",
    "Uwei",
    "Gocoter",
    "Craoruta",
    "Briuq XJ9"
  };
  String lettersAndNumbers = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  int type = floor(random(2));
  switch(type)
  {
  case 0:
    return planetNames[floor(random(planetNames.length))];
  case 1:
    String name = planetNames[floor(random(planetNames.length))] + " ";
    int additionalChars = floor(random(2, 4));
    for (int i = 0; i < additionalChars; i++)
      name += lettersAndNumbers.charAt(floor(random(lettersAndNumbers.length())));
    return name;
  default:
    return "PlaceHolderPlanetName";
  }
}

void createRandomInitialPlanets(int n)
{
  for(int i = 0; i < n; i++)
  {
    float x = random(50, 400) * (random(1) < 0.5 ? -1 : 1);
    float y = random(50, 400) * (random(1) < 0.5 ? -1 : 1);
    Body b = createNewRandomPlanetAtPosition(new PVector(x, y));
    setBodyInOrbitAroundGreatestAttractor(b, bodies);
  }
}

public void referencePlanetAtMousePosition(PVector mousePosWithOffset)
{
  Body previousReference = PlanetSelector.referencePlanet;
  PlanetSelector.setReferencePlanetAt(mousePosWithOffset.x, mousePosWithOffset.y, bodies, 1.2);
  if (PlanetSelector.referencePlanet == null && previousReference != null)
  {
    PlanetSelector.setReferencedPlanet(previousReference);
  } else
  {
    setGlobalCameraOffset(0, 0);
  }
}

public Body createOrSelectPlanetAtPosition(PVector mousePosWithOffset)
{
  if(PlanetSelector.selectPlanetAt(mousePosWithOffset.x, mousePosWithOffset.y, bodies, 1.2))
    return null;
  Body b = createNewRandomPlanetAtPosition(mousePosWithOffset);
  PlanetSelector.setSelectedPlanet(b);
  return b;
}

public Body createNewRandomPlanetAtPosition(PVector globalPosition)
{
  float x = globalPosition.x, y = globalPosition.y;
  float vx = 0, vy = 0;
  float ax = 0, ay = 0;
  float r = random(PLANET_MINIMUM_RADIUS, PLANET_MAXIMUM_RADIUS);
  float g = random(PLANET_MINIMUM_GRAVITY, PLANET_MAXIMUM_GRAVITY);
  color c = getRandomColor(0, 360, 250, 360, 270, 360);
  String name = getRandomPlanetName();

  Body body = createNewPlanet(x, y, vx, vy, ax, ay, r, g, false, c, name);
  return body;
}

public void setBodyInOrbitAroundGreatestAttractor(Body body, ArrayList<Body> bodies)
{
  Body greatestAttractor = null;
  float value = Float.MIN_VALUE;
  for (Body b : bodies)
  {
    if (b == body)
      continue;
    float dist = PVector.sub(body.position, b.position).magSq();
    float f = gravitationalForce(body, b) / dist;
    if (f > value)
    {
      value = f;
      greatestAttractor = b;
    }
  }
  if (greatestAttractor == null)
    return;

  PVector direction = PVector.sub(greatestAttractor.position, body.position);
  float distance = direction.mag();
  float orbitalVelocity = sqrt(G * greatestAttractor.mass / (distance * TIME_STEP_SIZE)); // Scale by time step so the simulation steps are the right size
  float rotation = HALF_PI * random(0.9, 1);
  float rotationFactor = random(1) < 0.5 ? -1 : 1;

  direction.setMag(orbitalVelocity);
  direction.rotate(rotation * rotationFactor);
  body.velocity.set(direction);
}

public void setSelectedPlanetVelocityTowardsMousePosition(PVector mousePosWithOffset)
{
  Body body = PlanetSelector.selectedPlanet;
  if (body != null)
  {
    if (body.fixed)
      return;
    PVector dir = PVector.sub(mousePosWithOffset, body.position);
    body.velocity.set(dir);
  }
}
