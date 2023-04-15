enum OnMouseClickModeEnum
{
  NONE,
    PLANET_CREATE_SELECT,
    PLANET_SET_REFERENCED,
}

public static class OnMouseClickModeEnumManager
{
  private static OnMouseClickModeEnum mode = OnMouseClickModeEnum.PLANET_CREATE_SELECT;
  public static OnMouseClickModeEnum getCurrentOnMouseClickModeEnum()
  {
    return mode;
  }
  public static void setMode(OnMouseClickModeEnum mode)
  {
    OnMouseClickModeEnumManager.mode = mode;
  }
  public static OnMouseClickModeEnum getMode()
  {
    return mode;
  }
  public static void cycleToNextMode() {
    switch(mode)
    {
    case NONE:
      setMode(OnMouseClickModeEnum.PLANET_CREATE_SELECT);
      break;
    case PLANET_CREATE_SELECT:
      setMode(OnMouseClickModeEnum.PLANET_SET_REFERENCED);
      break;
    case PLANET_SET_REFERENCED:
    default:
      setMode(OnMouseClickModeEnum.NONE);
    }
  }
}
