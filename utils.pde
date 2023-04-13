
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
      for(int i = 0; i < additionalChars; i++)
        name += lettersAndNumbers.charAt(floor(random(lettersAndNumbers.length())));
      return name;
    default:
      return "PlaceHolderPlanetName";
  }
}
