public class Checksum {

    public static void main(String[] args) {
        int small = Integer.parseInt(args[0]);
        int big = Integer.parseInt(args[0]);
        for (int i = 1; i < args.length; i++) {
            int now = Integer.parseInt(args[i]);
            if (now > big) {
                big = now;
            }
            if (now < small) {
                small = now;
            }
        }
        System.out.println(big - small);
    }

}
