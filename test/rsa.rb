def mpow(x,y,n)
    r_0 = 1
    puts "#{r_0} #{x} #{y}"
    while y > 0
        r_0 = (r_0 * x ) % n if y[0] == 1
        x = (x * x )% n
        puts "#{r_0} #{x} #{y}"
        y = y >> 1
    end
    r_0
end

def xgcd(a,b)
    prevx, x = 1, 0; prevy, y = 0, 1
    while b != 0
        q = a/b
        x, prevx = prevx - q*x, x
        y, prevy = prevy - q*y, y
        a, b = b, a % b
    end
    return a, prevx, prevy
end

def exgcd(e, phi)
    p_d = 1;
    d = 0;
    p_k = 0;
    k = 1;
    q = 0;
    tmp = 0;
    while phi != 0
        q = e / phi;

        tmp = d;
        d = p_d - q * d;
        p_d = tmp;


        tmp = k;
        k = p_k - q * k;
        p_k = tmp;
        tmp = e;
        e = phi;
        phi = tmp % phi;
        # $write("%d %d %d %d %d %d %d\n", q, e, phi, d,k, p_d, p_k);
    end
    return e, p_d, p_k
end
p exgcd(107,1007)