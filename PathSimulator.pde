public static class PathSimulator
{ 
  public static final int SIMULATION_STEPS = PATH_SIMULATOR_STEPS;
  
  public static void simulatePaths(ArrayList<Body> bodies, PVector a)
  {
    ArrayList<Body> copiedBodies = new ArrayList<Body>();
    
    Body simulatedReferenceBody = null;
    for(int i = 0; i < bodies.size(); i++)
    {
      Body b = bodies.get(i);
      Body c = b.clone();
      b.pathInformation.reset();
      c.pathInformation = b.pathInformation;
      
      copiedBodies.add(c);
      
      if(PlanetSelector.referencePlanet == b)
        simulatedReferenceBody = c;
    } 
    
    for(int i = 0; i < SIMULATION_STEPS; i++)
    {
      for(Body b : copiedBodies)
        b.attractExceptSelf(copiedBodies);
        
      for(int j = 0; j < copiedBodies.size(); j++)
        if(!copiedBodies.get(j).pathInformation.willCollide)
          copiedBodies.get(j).updatePosition();
        
      // Figure out if we have collided with something
      for(int j = 0; j < copiedBodies.size(); j++)
      {
        Body b = copiedBodies.get(j);
        if(b.pathInformation.willCollide)
          continue;
          
        for(int k = 0; k < copiedBodies.size(); k++)
        {
          if(j == k)
            continue;
          Body jBody = copiedBodies.get(j);
          Body other = copiedBodies.get(k);
          float sumr = other.radius + b.radius;
          float distSq = PVector.sub(jBody.position, other.position).magSq();
          if(distSq < sumr * sumr)
            jBody.pathInformation.willCollide = true;
        }
        
        // This part is a bit questionable because it 
        // offsets the path by the reference planed in PlanetSelector.
        // We do this so we can draw the paths in relation to how they move 
        // with respect to the reference planet. A bit hacky to do it here but it works
        PVector pathPos = b.position.copy();
        if(simulatedReferenceBody != null)
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
