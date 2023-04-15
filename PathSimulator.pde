public static class PathSimulator
{
  public static final int SIMULATION_STEPS = PATH_SIMULATOR_STEPS;
  private static int previousSimulationSteps = SIMULATION_STEPS;

  private static ArrayList<Body> copiedBodies = new ArrayList<Body>();
  private static Body simulatedReferenceBody = null;
  public static void simulatePaths(ArrayList<Body> bodies, PVector a, float frameRate)
  {
    copiedBodies.clear();
    simulatedReferenceBody = null;

    for (int i = 0; i < bodies.size(); i++)
    {
      Body b = bodies.get(i);
      Body c = b.clone();
      b.pathInformation.reset();
      c.pathInformation = b.pathInformation;

      copiedBodies.add(c);

      if (PlanetSelector.referencePlanet == b)
        simulatedReferenceBody = c;
    }

    int SIM_STEPS_TO_DO = previousSimulationSteps;

    /**********************************************************************/
    // Dynamically change how many simulation steps we have
    float fpsDifference = frameRate - DESIRED_FRAMERATE;
    if (-1 < fpsDifference || fpsDifference < 1)
      SIM_STEPS_TO_DO += round(fpsDifference * DYNAMIC_SIM_STEPS_FACTOR);
    SIM_STEPS_TO_DO = max(SIM_STEPS_TO_DO, 0);
    previousSimulationSteps = SIM_STEPS_TO_DO;
    /**********************************************************************/
    for (int i = 0; i < SIM_STEPS_TO_DO; i++)
    {
      calculateAttractions(copiedBodies);
      /*
      for (Body b : copiedBodies)
        b.attractExceptSelf(copiedBodies);
      */
      //calculateAttractions(copiedBodies);
      for (int j = 0; j < copiedBodies.size(); j++)
        if (!copiedBodies.get(j).pathInformation.willCollide)
          copiedBodies.get(j).updatePosition();

      // Figure out if we have collided with something
      for (int j = 0; j < copiedBodies.size(); j++)
      {
        Body b = copiedBodies.get(j);
        if (b.pathInformation.willCollide)
          continue;

        for (int k = 0; k < copiedBodies.size(); k++)
        {
          if (j == k)
            continue;
          Body jBody = copiedBodies.get(j);
          Body other = copiedBodies.get(k);
          float sumr = other.radius + b.radius;
          float distSq = PVector.sub(jBody.position, other.position).magSq();
          if (distSq < sumr * sumr)
            jBody.pathInformation.willCollide = true;
        }

        // This part is a bit questionable because it
        // offsets the path by the reference planed in PlanetSelector.
        // We do this so we can draw the paths in relation to how they move
        // with respect to the reference planet. A bit hacky to do it here but it works
        PVector pathPos = b.position.copy();
        if (simulatedReferenceBody != null)
        {
          pathPos = pathPos.sub(simulatedReferenceBody.position);
          pathPos = pathPos.add(PlanetSelector.referencePlanet.position);
        }

        bodies.get(j).pathInformation.path.add(pathPos);
      }
    }
  }
}

public class SimulatedPathInformation
{
  public ArrayList<PVector> path;
  public boolean willCollide;
  public SimulatedPathInformation()
  {
    path = new ArrayList<PVector>();
    willCollide = false;
  }
  public void reset()
  {
    path.clear();
    willCollide = false;
  }
}
