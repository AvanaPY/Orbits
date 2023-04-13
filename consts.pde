
// Simulation constants
public static final float TIME_STEP_SIZE = 1 / 200f;
public static final int STEPS_PER_FRAME = 2;
public static final int PATH_SIMULATOR_STEPS = 5000;

// Physics constants
public static final float G = 0.01;
public static final float MASS_SCALE_FACTOR = 0.05;


// Planet liminations
public static final float PLANET_MINIMUM_RADIUS  = 3f;
public static final float PLANET_MAXIMUM_RADIUS  = 20f;
public static final float PLANET_MINIMUM_GRAVITY = 1f;
public static final float PLANET_MAXIMUM_GRAVITY = 50f;

// Planet data
public static String[] PLANET_NAMES = {};

// UI Data
public final int COLOR_MODE = HSB;
public final color backgroundColor = color(120, 120);
public final color borderColor = color(360);
public final color textColor = color(170, 360, 360);
public final int textSize = 12;
public final color UI_ELEMENT_COLOR = color(190, 200, 50);
