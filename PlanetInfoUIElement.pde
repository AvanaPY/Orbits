public class UIEditableTextElement extends UIElement
{
  private String prependText;
  private IBodyTextDataGetter i;
  private boolean centered;
  public UIEditableTextElement(float x, float y, float w, float h, IBodyTextDataGetter i, String prependText, boolean centered)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;
    this.centered = centered;
  }
  public String getRenderText(Body selectedBody)
  {
    return prependText + i.getData(selectedBody);
  }

  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);
    if (centered)
    {
      textAlign(CENTER, CENTER);
      text(getRenderText(selectedBody), x + maxWidth / 2, y + maxHeight / 2);
    } else
    {
      textAlign(LEFT, CENTER);
      text(getRenderText(selectedBody), x, y + maxHeight / 2);
    }
  }
  public void click(float mx, float my) {}
}

public class UIEditableFloatElement extends UIElement
{
  private UIClickableButton[] btns;
  private String prependText;
  private IBodyFloatDataGetter i;

  public UIEditableFloatElement(float x, float y, float w, float h,  IBodyFloatDataGetter i, String prependText)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;

    btns = new UIClickableButton[0];
  }
  
  public UIEditableFloatElement(float x, float y, float w, float h, IBodyFloatDataGetter i,
    IBodyInteractiveAction buttonAction01, String buttonText01,
    String prependText)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;

    btns = new UIClickableButton[1];
    btns[0] = new UIClickableButton(w / 2, y, w / 2, h, buttonAction01, buttonText01);
  }
  
  public UIEditableFloatElement(float x, float y, float w, float h, IBodyFloatDataGetter i,
    IBodyInteractiveAction buttonAction01, String buttonText01,
    IBodyInteractiveAction buttonAction02, String buttonText02,
    String prependText)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;

    btns = new UIClickableButton[2];
    btns[0] = new UIClickableButton(w / 2, y, w / 4, h, buttonAction01, buttonText01);
    btns[1] = new UIClickableButton(w * 3 / 4, y, w / 4, h, buttonAction02, buttonText02);
  }
  
  public String getRenderText(Body selectedBody)
  {
    return prependText + nf(i.getData(selectedBody), 1, 2);
  }

  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);

    textAlign(LEFT, CENTER);
    text(getRenderText(selectedBody), x + 5, y + maxHeight / 2);
    
    if(btns != null)
      for(UIClickableButton btn : btns)
         btn.render();
  }
  public void click(float mx, float my)
  {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;
    
    for(UIClickableButton btn : btns)
    {
      btn.click(mx, my);
    }
  }
}

public class UIEditableBooleanElement extends UIElement
{
  private UIClickableButton[] btns;
  private String prependText;
  private IBodyBooleanDataGetter i;

  public UIEditableBooleanElement(float x, float y, float w, float h,  IBodyBooleanDataGetter i, String prependText)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;

    btns = new UIClickableButton[0];
  }
  
  public UIEditableBooleanElement(float x, float y, float w, float h, IBodyBooleanDataGetter i,
    IBodyInteractiveAction buttonAction01, String buttonText01,
    String prependText)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.i = i;
    this.prependText = prependText;

    btns = new UIClickableButton[1];
    btns[0] = new UIClickableButton(w / 2, y, w / 2, h, buttonAction01, buttonText01);
  }
  
  public String getRenderText(Body selectedBody)
  {
    return prependText + i.getData(selectedBody);
  }

  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);

    textAlign(LEFT, CENTER);
    text(getRenderText(selectedBody), x + 5, y + maxHeight / 2);
    
    if(btns != null)
      for(UIClickableButton btn : btns)
         btn.render();
  }
  public void click(float mx, float my)
  {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;
    
    for(UIClickableButton btn : btns)
    {
      btn.click(mx, my);
    }
  }
}

public class UIClickableButton extends UIElement
{
  private String text;
  private IBodyInteractiveAction action;
  public UIClickableButton(float x, float y, float w, float h, IBodyInteractiveAction action, String text)
  {
    this.x = x;
    this.y = y;
    this.maxWidth = w;
    this.maxHeight = h;
    this.text = text;
    this.action = action;
  }
  public String getRenderText(Body selectedBody)
  {
    return text;
  }
  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);

    textAlign(CENTER, CENTER);
    text(getRenderText(selectedBody), x + maxWidth / 2, y + maxHeight / 2);
  }
  public void click(float mx, float my)
  {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;

    action.action();
  }
}
