public class Lasagna {
    private static final int EXPECTED_MINUTES_IN_OVEN = 40;
    private static final int PREPARATION_TIME_IN_MINUTES = 2;
    public int expectedMinutesInOven(){
        return EXPECTED_MINUTES_IN_OVEN;
    }
    public int remainingMinutesInOven(int timeInOven){
        return expectedMinutesInOven() - timeInOven;
    }
    public int preparationTimeInMinutes(int layers){
        return layers * PREPARATION_TIME_IN_MINUTES;
    }
    public int totalTimeInMinutes(int layers, int timeInOven){
        return preparationTimeInMinutes(layers) + timeInOven;
    }
}
