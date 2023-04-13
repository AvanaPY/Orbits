public static class PathSimulator
{ 
  public static final int SIMULATION_STEPS = PATH_SIMULATOR_STEPS;
  
  public static void simulatePaths(ArrayList<Body> bodies, PVector a)
  {
    Body[] bodiesArray = new Body[bodies.size()];
    
    Body simulatedReferenceBody = null;
    for(int i = 0; i < bodies.size(); i++)
    {
      bodies.get(i).pathInformation.reset();  
      bodiesArray[i] = bodies.get(i).clone();
      bodiesArray[i].pathInformation = bodies.get(i).pathInformation;
      
      if(PlanetSelector.referencePlanet == bodies.get(i))
        simulatedReferenceBody = bodiesArray[i];
    } 
    
    for(int i = 0; i < SIMULATION_STEPS; i++)
    {
      for(Body b : bodiesArray)
        b.attractExceptSelf(bodiesArray);
        
      for(int j = 0; j < bodiesArray.length; j++)
        if(!bodiesArray[j].pathInformation.willCollide)
          bodiesArray[j].updatePosition();
        
      // Figure out if we have collided with something
      for(int j = 0; j < bodiesArray.length; j++)
      {
        Body b = bodiesArray[j];
        for(int k = 0; k < bodiesArray.length; k++)
        {
          if(j == k)
            continue;
          Body other = bodiesArray[k];
          float sumr = other.radius + b.radius;
          float distSq = PVector.sub(bodiesArray[j].position, bodiesArray[k].position).magSq();
          if(distSq < sumr * sumr)
            bodiesArray[j].pathInformation.willCollide = true;
        }
        
        if (i % 2 == 0)
        {
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
