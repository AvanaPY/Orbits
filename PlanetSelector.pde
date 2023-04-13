public static class PlanetSelector
{
  private static Body selectedPlanet;
  private static Body referencePlanet;
  
  public static boolean selectPlanetAt(float x, float y, ArrayList<Body> bodies, float selectionTolerance)
  {
    selectedPlanet = null;
    for(Body body : bodies)
    {
      float distanceSq = new PVector(x, y).sub(body.position).magSq();
      if(distanceSq <= body.radius * body.radius * selectionTolerance)
      {
        selectedPlanet = body;
        return true;
      }
    }
    return false;
  }
  
  public static boolean setReferencePlanetAt(float x, float y, ArrayList<Body> bodies, float selectionTolerance)
  {
    referencePlanet = null;
    for(Body body : bodies)
    {
      float distanceSq = (float)(new PVector((float)x, (float)y).sub(body.position).magSq());
      if(distanceSq <= body.radius * body.radius * selectionTolerance)
      {
        referencePlanet = body;
        return true;
      }
    }
    return false;
  }
  
  public static void setSelectedPlanet(Body body)
  {
    selectedPlanet = body;
  }
  
  public static Body getCurrentlySelectedPlanet()
  {
    return selectedPlanet;
  }
  
  public static void setReferencedPlanet(Body body)
  {
    referencePlanet = body;
  }
  public static Body getCurrentlyReferencedPlanet()
  {
    return referencePlanet;
  }
}
