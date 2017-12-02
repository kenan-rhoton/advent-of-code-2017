public class Checksum2 {

    public static void main(String[] args) {
        for (int i = 0; i < args.length; i++) {
            for (int j = 0; j < args.length; j++) {
                if (i == j) {
                    continue;
                }
                int one = Integer.parseInt(args[i]);
                int two = Integer.parseInt(args[j]);
                if (one % two == 0) {
                    System.out.println(one / two);
                }
            }
        }
    }

}
