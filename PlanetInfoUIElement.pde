public class UIEditableTextElement extends UIElement
{
  private String text;
  private BodyTextDataGetter i;
  private boolean centered;
  public UIEditableTextElement(float x, float y, float w, float h, BodyTextDataGetter i, String text, boolean centered)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;
    this.centered = centered;
  }
  public String getRenderText(Body selectedBody)
  {
    return text + i.getData(selectedBody);
  }

  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();

    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);
    
    fill(textColor);
    textSize(textSize);
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
  public void click(float mx, float my) {
  }
}

public class UIEditableFloatElement extends UIElement
{
  private UIClickableButton[] btns;
  private String text;
  private BodyFloatDataGetter i;

  public UIEditableFloatElement(float x, float y, float w, float h, BodyFloatDataGetter i, String text)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;

    btns = new UIClickableButton[] {};
  }

  public UIEditableFloatElement(float x, float y, float w, float h, BodyFloatDataGetter i,
    InteractiveAction buttonAction01, String buttonText01,
    String text)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;

    btns = new UIClickableButton[] {
      btns[0] = new UIClickableButton(w / 2, y, w / 2, h, buttonAction01, buttonText01)
    };
  }

  public UIEditableFloatElement(float x, float y, float w, float h, BodyFloatDataGetter i,
    InteractiveAction buttonAction01, String buttonText01,
    InteractiveAction buttonAction02, String buttonText02,
    String text)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;

    btns = new UIClickableButton[] {
      new UIClickableButton(w / 2, y, w / 4, h, buttonAction01, buttonText01),
      new UIClickableButton(w * 3 / 4, y, w / 4, h, buttonAction02, buttonText02)
    };
  }

  public String getRenderText(Body selectedBody)
  {
    return text + nf(i.getData(selectedBody), 1, 2);
  }

  public void render()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(selectedBody), x + 5, y + maxHeight / 2);

    if (btns != null)
      for (UIClickableButton btn : btns)
        btn.render();
  }
  public void click(float mx, float my)
  {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;

    for (UIClickableButton btn : btns)
    {
      btn.click(mx, my);
    }
  }
}

public class UIEditableBooleanElement extends UIElement
{
  private UIClickableButton[] btns;
  private String text;
  private BodyBooleanDataGetter i;

  public UIEditableBooleanElement(float x, float y, float w, float h, BodyBooleanDataGetter i, String text)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;

    btns = new UIClickableButton[0];
  }

  public UIEditableBooleanElement(float x, float y, float w, float h, BodyBooleanDataGetter i,
    InteractiveAction buttonAction01, String buttonText01,
    String text)
  {
    super(x, y, w, h);
    this.i = i;
    this.text = text;

    btns = new UIClickableButton[1];
    btns[0] = new UIClickableButton(w / 2, y, w / 2, h, buttonAction01, buttonText01);
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
    rect(x, y, maxWidth / 4f, maxHeight);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER); 
    text(getRenderText(selectedBody), x + 5, y + maxHeight / 2);
    
    float centerCell01 = x + maxWidth / 4f + maxWidth / 8f;
    String booleanString = str(i.getData(selectedBody));
    booleanString = booleanString.substring(0,1).toUpperCase() + booleanString.substring(1).toLowerCase();

    textAlign(CENTER, CENTER);
    fill(i.getData(selectedBody) ? color(120, 360, 360) : color(40, 360, 360));
    text(booleanString, centerCell01, y + maxHeight / 2);

    fill(textColor);
    textSize(textSize);
    if (btns != null)
      for (UIClickableButton btn : btns)
        btn.render();
  }
  public void click(float mx, float my)
  {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;

    for (UIClickableButton btn : btns)
    {
      btn.click(mx, my);
    }
  }
}


public class UIDisplayablePVectorElement extends UIElement
{
  private String text;
  private BodyPVectorDataGetter dataGetter;
  public UIDisplayablePVectorElement(float x, float y, float w, float h, String text, BodyPVectorDataGetter dataGetter) {
    super(x, y, w, h);
    this.text = text;
    this.dataGetter = dataGetter;
  }
  
  public String getRenderText(Body selectedBody) {
    return text;
  }
  
  public void render()
  {
    Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();
    
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth / 2, maxHeight);
    rect(x + maxWidth / 2, y, maxWidth / 4, maxHeight);
    rect(x + maxWidth * 3 / 4, y, maxWidth / 4, maxHeight);
    
    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(null), x + 5, y + maxHeight / 2);
    
    PVector displayVector = dataGetter.getData(selectedPlanet);
    float centerCell01 = x + maxWidth / 2f + maxWidth / 8f;
    float centerCell02 = x + maxWidth / 2f + maxWidth / 4f + maxWidth / 8f;
    
    textAlign(CENTER, CENTER);
    text(nf(displayVector.x, 1, 1), centerCell01, y + maxHeight / 2);
    text(nf(displayVector.y, 1, 1), centerCell02, y + maxHeight / 2);
  }
  public void click(float mx, float my) {}
}

public class UIDisplayableColorElement extends UIElement
{
  private String text;
  private BodyColorDataGetter dataGetter;
  public UIDisplayableColorElement(float x, float y, float w, float h, String text, BodyColorDataGetter dataGetter)
  {
    super(x, y, w, h);
    this.text = text;
    this.dataGetter = dataGetter;
  }
  
  public String getRenderText(Body selectedBody) {
    return text;
  }
  
  public void render()
  {
    Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();
    
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);
    line(x + maxWidth / 2, y, x + maxWidth / 2, y + maxHeight);
    line(x + maxWidth * 4 / 6, y, x + maxWidth * 4 / 6, y + maxHeight); 
    line(x + maxWidth * 5 / 6, y, x + maxWidth * 5 / 6, y + maxHeight); 
    
    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(null), x + 5, y + maxHeight / 2);
    
    color c = dataGetter.getData(selectedPlanet);
    float r = hue(c), g = saturation(c), b = brightness(c);
    
    float centerCell01 = x + maxWidth / 2f + maxWidth * 1 / 12f;
    float centerCell02 = x + maxWidth / 2f + maxWidth * 3 / 12f;
    float centerCell03 = x + maxWidth / 2f + maxWidth * 5 / 12f;
    
    textAlign(CENTER, CENTER);
    text(nf(r, 1, 0), centerCell01, y + maxHeight / 2);
    text(nf(g, 1, 0), centerCell02, y + maxHeight / 2);
    text(nf(b, 1, 0), centerCell03, y + maxHeight / 2);
  }
  public void click(float mx, float my) {}
}


public class UIClickableButton extends UIElement
{
  private String text;
  private InteractiveAction action;
  public UIClickableButton(float x, float y, float w, float h, InteractiveAction action, String text) {
    super(x, y, w, h);
    this.text = text;
    this.action = action;
  }
  
  public String getRenderText(Body selectedBody) {
    return text;
  }
  
  public void render() {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, maxWidth, maxHeight);

    textAlign(CENTER, CENTER);
    text(getRenderText(selectedBody), x + maxWidth / 2, y + maxHeight / 2);
  }
  
  public void click(float mx, float my) {
    if (mx < x || mx > x + maxWidth || my < y || my > y + maxHeight)
      return;

    action.action();
  }
}
