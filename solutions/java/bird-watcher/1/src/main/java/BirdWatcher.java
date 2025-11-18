
class BirdWatcher {
    private final int[] birdsPerDay;

    public BirdWatcher(int[] birdsPerDay) {
        this.birdsPerDay = birdsPerDay.clone();
    }

    public int[] getLastWeek() {
        return new int[] {0, 2, 5, 3, 7, 8, 4};
    }

    public int getToday() {
        return this.birdsPerDay[this.birdsPerDay.length - 1];
    }

    public void incrementTodaysCount() {
        this.birdsPerDay[this.birdsPerDay.length - 1]++;
    }

    public boolean hasDayWithoutBirds() {
        for(int i = 0; i < this.birdsPerDay.length; i++){
            if(this.birdsPerDay[i] == 0){
                return true;
            }
        }
        return false;
    }

    public int getCountForFirstDays(int numberOfDays) {
        int count = 0;
        if(numberOfDays > this.birdsPerDay.length){
            numberOfDays = this.birdsPerDay.length;
        }
        for(int i = 0; i < numberOfDays; i++){
            count += this.birdsPerDay[i];
        }
        return count;
    }

    public int getBusyDays() {
        int count = 0;
        for(int i = 0; i < this.birdsPerDay.length; i++){
            if(this.birdsPerDay[i] > 4){
                count++;
            }
        }
        return count;
    }
}
