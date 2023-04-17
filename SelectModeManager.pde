enum OnMouseClickModeEnum
{
  NONE,
    PLANET_CREATE_SELECT,
    PLANET_CREATE_MOON,
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
  public static OnMouseClickModeEnum cycleToNextMode() {
    switch(mode)
    {
    case NONE:
      setMode(OnMouseClickModeEnum.PLANET_CREATE_SELECT);
      break;
    case PLANET_CREATE_SELECT:
      setMode(OnMouseClickModeEnum.PLANET_CREATE_MOON);
      break;
    case PLANET_CREATE_MOON:
    default:
      setMode(OnMouseClickModeEnum.PLANET_CREATE_SELECT);
    }
    return getMode();
  }
  public static String getCurrentModeAsDisplayString()
  {
    switch(mode)
    {
    case PLANET_CREATE_SELECT:
      return "Select/Create";
    case PLANET_CREATE_MOON:
      return "Create Moon";
    case NONE:
    default:
      break;
    }
    return "PH_TEXT";
  }
}
