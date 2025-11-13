public class Lasagna {
    public int expectedMinutesInOven(){
        return 40;
    }
    public int remainingMinutesInOven(int timeInOven){
        return 40 - timeInOven;
    }
    public int preparationTimeInMinutes(int layers){
        return layers * 2;
    }
    public int totalTimeInMinutes(int layers, int timeInOven){
        return preparationTimeInMinutes(layers) + timeInOven;
    }
}
