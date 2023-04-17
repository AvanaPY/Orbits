public static class Keybind
{
  private String name;
  private char keybind;
  private int codedKeybind;
  
  private String displayName;
  private String displayKeybind;
  private InteractiveAction action;
  public Keybind(String n, char k, String dName, String dKeybind, InteractiveAction action){
    name = n;
    keybind = k;
    codedKeybind = -1;
    displayName = dName;
    displayKeybind = dKeybind;
    this.action = action;
    
  }
  
  public Keybind(String n, int k, String dName, String dKeybind, InteractiveAction action){
    name = n;
    keybind = '\0';
    codedKeybind = k;
    displayName = dName;
    displayKeybind = dKeybind;
    this.action = action;
    
  }
  public Keybind(String n, char k, String dName, InteractiveAction action)
  {
    this(n, k, dName, str(k).toUpperCase(), action);
  }
  
  public Keybind(String n, char k, InteractiveAction action)
  {
    this(n, k, n, str(k).toUpperCase(), action);
  }
  
  public void action()
  {
    action.action();
  }
}
public static class KeybindManager
{
  public static KeybindManager instance;
  public ArrayList<Keybind> keybinds;
  private HashMap<String, Character> keybindNameMap;
  private HashMap<Character, Keybind> keybindMap;
  private HashMap<Integer, Keybind> codedKeybindMap;
  public KeybindManager()
  {
    KeybindManager.instance = this;
    keybinds = new ArrayList<Keybind>();
    keybindNameMap = new HashMap<String, Character>();
    keybindMap = new HashMap<Character, Keybind>();
    codedKeybindMap = new HashMap<Integer, Keybind>();
  }
  
  public Keybind getKeybind(char c)
  {
    return keybindMap.get(c);
  }
  
  public Keybind getCodedKeybind(int code)
  {
    return codedKeybindMap.get(code);
  }
  
  public void addKeybind(String keybindName, char keybindChar, String displayName, String displayKeybind, InteractiveAction action){
    if(getKeybind(keybindChar) != null)
    {
      println("KEYBIND COLLISION: Trying to assign new action to keybind '" + keybindChar + "'");
      return;
    }
      
    Keybind keybind = new Keybind(keybindName, keybindChar, displayName, displayKeybind, action);
    
    keybinds.add(keybind);
    keybindNameMap.put(keybind.name, keybind.keybind);
    keybindMap.put(keybindChar, keybind);
  }
  
  public void addCodedKeybind(String keybindName, int code, String displayName, String displayKeybind, InteractiveAction action)
  {
    if(getCodedKeybind(code) != null)
    {
      println("CODED KEYBIND COLLISION: Trying to assign new action to keybind '" + code + "'");
      return;
    }
      
    Keybind keybind = new Keybind(keybindName, code, displayName, displayKeybind, action);
    
    keybinds.add(keybind);
    keybindNameMap.put(keybind.name, keybind.keybind);
    codedKeybindMap.put(code, keybind);
  }

  public boolean isKey(Character k, String name)
  {
    Character boundedKey = keybindNameMap.get(name);
    return boundedKey == k;
  }
  
  public boolean activateKeybind(char c)
  {
    Keybind k = getKeybind(c);
    if(k != null)
    {
      k.action();
      return true;
    }
    return false;
  }
  
  public boolean activateCodedKeybind(int c)
  {
    Keybind k = getCodedKeybind(c);
    if(k != null)
    {
      k.action();
      return true;
    }
    return false;
  }
}

public static KeybindManager getGlobalKeybindManager()
{
  return KeybindManager.instance; 
}
