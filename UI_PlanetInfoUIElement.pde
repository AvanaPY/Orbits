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

  public void renderUI()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();

    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, w, h);

    fill(textColor);
    textSize(textSize);
    if (centered)
    {
      textAlign(CENTER, CENTER);
      text(getRenderText(selectedBody), x + w / 2, y + h / 2);
    } else
    {
      textAlign(LEFT, CENTER);
      text(getRenderText(selectedBody), x, y + h / 2);
    }
  }
  public boolean onClick(float mx, float my) {
    return false;
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

  public void renderUI()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    strokeWeight(1);
    rect(x, y, w, h);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(selectedBody), x + 5, y + h / 2);

    if (btns != null)
      for (UIClickableButton btn : btns)
        btn.render();
  }
  public boolean onClick(float mx, float my)
  {
    if(positionInElement(mx, my))
      for (UIClickableButton btn : btns)
        if (btn.onClick(mx, my))
          return true;
          
    return false;
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

  public void renderUI()
  {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();

    noFill();
    strokeWeight(1);
    rect(x, y, w, h);
    rect(x, y, w / 4f, h);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(selectedBody), x + 5, y + h / 2);

    float centerCell01 = x + w / 4f + w / 8f;
    String booleanString = str(i.getData(selectedBody));
    booleanString = booleanString.substring(0, 1).toUpperCase() + booleanString.substring(1).toLowerCase();

    textAlign(CENTER, CENTER);
    fill(i.getData(selectedBody) ? color(120, 360, 360) : color(40, 360, 360));
    text(booleanString, centerCell01, y + h / 2);

    fill(textColor);
    textSize(textSize);
    if (btns != null)
      for (UIClickableButton btn : btns)
        btn.render();
  }
  public boolean onClick(float mx, float my)
  {
    if (mx < x || mx > x + w || my < y || my > y + h)
      return false;

    for (UIClickableButton btn : btns)
      if (btn.onClick(mx, my))
        return true;
    return false;
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

  public void renderUI()
  {
    Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();

    noFill();
    strokeWeight(1);
    rect(x, y, w / 2, h);
    rect(x + w / 2, y, w / 4, h);
    rect(x + w * 3 / 4, y, w / 4, h);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(null), x + 5, y + h / 2);

    PVector displayVector = dataGetter.getData(selectedPlanet);
    float centerCell01 = x + w / 2f + w / 8f;
    float centerCell02 = x + w / 2f + w / 4f + w / 8f;

    textAlign(CENTER, CENTER);
    text(nf(displayVector.x, 1, 1), centerCell01, y + h / 2);
    text(nf(displayVector.y, 1, 1), centerCell02, y + h / 2);
  }
  public boolean onClick(float mx, float my) {
    return false;
  }
}

public class UIDisplayableColorElement extends UIElement
{
  private final String text;
  private final BodyColorDataGetter dataGetter;
  private final float centerCell01, centerCell02, centerCell03; // 3 cells for HSB or RGB
  public UIDisplayableColorElement(float x, float y, float w, float h, String text, BodyColorDataGetter dataGetter)
  {
    super(x, y, w, h);
    this.text = text;
    this.dataGetter = dataGetter;
    centerCell01 = x + w / 2f + w * 1 / 12f;
    centerCell02 = x + w / 2f + w * 3 / 12f;
    centerCell03 = x + w / 2f + w * 5 / 12f;
  }

  public String getRenderText(Body selectedBody) {
    return text;
  }

  public void renderUI()
  {
    Body selectedPlanet = PlanetSelector.getCurrentlySelectedPlanet();

    noFill();
    strokeWeight(1);
    rect(x, y, w, h);
    line(x + w / 2, y, x + w / 2, y + h);
    line(x + w * 4 / 6, y, x + w * 4 / 6, y + h);
    line(x + w * 5 / 6, y, x + w * 5 / 6, y + h);

    fill(textColor);
    textSize(textSize);
    textAlign(LEFT, CENTER);
    text(getRenderText(null), x + 5, y + h / 2);

    color c = dataGetter.getData(selectedPlanet);
    int r, g, b;
    if (COLOR_MODE == HSB)
    {
      r = round(hue(c));
      g = round(saturation(c));
      b = round(brightness(c));
    } else if (COLOR_MODE == RGB)
    {
      r = round(red(c));
      g = round(green(c));
      b = round(blue(c));
    }

    textAlign(CENTER, CENTER);
    text(r, centerCell01, y + h / 2);
    text(g, centerCell02, y + h / 2);
    text(b, centerCell03, y + h / 2);
  }
  public boolean onClick(float mx, float my) {
    return false;
  }
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

  public void renderUI() {
    Body selectedBody = PlanetSelector.getCurrentlySelectedPlanet();
    noFill();
    stroke(0, 0, 0);
    strokeWeight(1);
    rect(x, y, w, h);

    textAlign(CENTER, CENTER);
    text(getRenderText(selectedBody), x + w / 2, y + h / 2);
  }

  public boolean onClick(float mx, float my) {
    if (mx < x || mx > x + w || my < y || my > y + h)
      return false;

    action.action();
    return true;
  }
}
