

public void USER_ACTION_SetSelectedAsReference()
{
  Body s = PlanetSelector.getCurrentlySelectedPlanet();
  if (s != null) {
    referencePlanetOffset.set(0, 0);
    PlanetSelector.setReferencedPlanet(s);
  }
}

public void USER_ACTION_DeselectSelectedPlanet()
{
  PlanetSelector.setSelectedPlanet(null);
}

public void USER_ACTION_ResetReferenceOffset()
{
  referencePlanetOffset.add(PlanetSelector.getCurrentlyReferencedPlanet().position);
  PlanetSelector.setReferencedPlanet(sun);
}

public void USER_ACTION_ChangeSelectedPlanetVelocity(float dx, float dy)
{
  Body b = PlanetSelector.getCurrentlySelectedPlanet();
  if (b == null)
    return;
  b.velocity.add(dx, dy);
}

public void USER_ACTION_CycleNextClickMode() {
  OnMouseClickModeEnum mode = OnMouseClickModeEnumManager.cycleToNextMode();
  switch(mode)
  {
  case PLANET_CREATE_SELECT:
  cursorModeManager.setCursorMode(CursorMode.CIRCLE);
  cursorModeManager.setCursorColor(color(0, 0, 360, 240));
    break;
  case PLANET_CREATE_MOON:
  cursorModeManager.setCursorMode(CursorMode.CIRCLE);
  cursorModeManager.setCursorColor(color(0, 360, 360, 360));
    break;
  case NONE:
  default:
    break;
  }
}
