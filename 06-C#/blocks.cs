using System;
using System.Linq;
using System.Collections.Generic;

public class Blocks
{
    static public void Main ()
    {
        var numbers = Console.ReadLine().Split();
        List<int> ints = new List<int>();
        foreach (var n in numbers) {
            int i;
            if (int.TryParse(n, out i)) {
                ints.Add(i);
            }
        }
        var next = true;
        List<List<int>> Configurations = new List<List<int>>();
        int counter = 0;
        while (next) {
            counter = 0;
            foreach (var c in Configurations) {
                counter ++;
                next = false;
                for (var i = 0; i < c.Count; i++) {
                    if (c[i] != ints[i]) {
                        next = true;
                        break;
                    }
                }
                if (!next) {
                    break;
                }
            }
            Configurations.Add(new List<int>(ints));
            var max = 0;
            for (var i = 1; i < ints.Count; i++) {
                if (ints[i] > ints[max]) {
                    max = i;
                }
            }
            var blocks = ints[max];
            ints[max] = 0;
            while (blocks > 0) {
                max++;
                max = max % ints.Count;
                ints[max]++;
                blocks--;
            }
        }
        Console.WriteLine(Configurations.Count - 1);
        Console.WriteLine(Configurations.Count - counter);
    }
}
