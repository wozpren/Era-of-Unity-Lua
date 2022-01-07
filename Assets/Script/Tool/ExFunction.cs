using System;
using EraHF;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public static class ExFunction
{
    public static bool Contain(this List<string> list, string name)
    {
        foreach (var item in list)
        {
            if (item.Contains(name))
                return true;
        }
        return false;
    }

    public static bool ContainKey(this Dictionary<string, int> dic, string name)
    {
        foreach (var item in dic)
        {
            if (item.Key.Contains(name))
                return true;
        }
        return false;
    }

    public static bool Contain(this string[] dic, string name)
    {
        foreach (var item in dic)
        {
            if (item.Contains(name))
                return true;
        }
        return false;
    }
    public static T GetRandom<T>(this List<T> order)
    {
        var index = UnityEngine.Random.Range(0, order.Count);
        return order[index];
    }

    public static int Sigma(int number, int n)
    {
        int result = 0;
        for (int i = 0; i < n; i++)
        {
            result += number - i;
        }
        return result;
    }
    public static void Add(this Dictionary<string, int> l, Dictionary<string, int> r)
    {
        foreach (var item in r)
        {
            if (l.ContainsKey(item.Key))
            {
                l[item.Key] += item.Value;
            }
            else
            {
                l.Add(item.Key, item.Value);
            }
        }
    }

    public static void Update(this Dictionary<string, int> dic, string key, int value)
    {
        if (dic.ContainKey(key))
        {
            dic[key] += value;
        }
        else
        {
            dic.Add(key, value);
        }
    }

    public static int IsUP(this string world)
    {
        int n = 0;
        for (int i = 0; i < world.Length; i++)
        {
            if (world[i] > 'A' && world[i] < 'Z')
                n++;
        }

        return n;
    }


    public static bool TryPeek(this Stack<string> stack, out string arg)
    {
        if(stack.Count > 0)
        {
            arg = stack.Peek();
            return true;
        }
        else
        {
            arg = null;
            return false;
        }
    }

    public static bool TryPop(this Stack<string> stack, out string arg)
    {
        if (stack.Count > 0)
        {
            arg = stack.Pop();
            return true;
        }
        else
        {
            arg = null;
            return false;
        }
    }
}