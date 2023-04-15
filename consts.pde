// Generic data
public static final int DESIRED_FRAMERATE = 60;

// Simulation constants
public static final float TIME_STEP_SIZE = 1 / 100f;
public static final int STEPS_PER_FRAME = 4;
public static final int PATH_SIMULATOR_STEPS = 5000;
public static final float DYNAMIC_SIM_STEPS_FACTOR = 0.5; // How large steps to take when dynamically changing how many simulation steps we do in order to keep framerate at a desired state

// Physics constants
public static final float G = 0.01;
public static final float M = 0.1;


// Planet liminations
public static final float PLANET_MINIMUM_RADIUS  = 3f;
public static final float PLANET_MAXIMUM_RADIUS  = 10f;
public static final float PLANET_MINIMUM_GRAVITY = 0.01f;
public static final float PLANET_MAXIMUM_GRAVITY = 30f;

// Planet data
public static String[] PLANET_SET_SELECTED_NAMES = {};

// UI Data
public final int COLOR_MODE = HSB;
public final color backgroundColor = color(120, 120);
public final color borderColor = color(360);
public final color textColor = color(170, 360, 360);
public final int textSize = 12;
public final color UI_ELEMENT_COLOR = color(190, 200, 50);
