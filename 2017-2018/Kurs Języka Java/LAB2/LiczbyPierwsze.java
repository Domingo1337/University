import java.util.ArrayList;
import java.util.List;

public final class LiczbyPierwsze
{
    private final static int POTEGA2 = 21;
    private final static int[] SITO = new int[1<<POTEGA2] ;

    static{
        for(int i=2; i < SITO.length; i++)
            SITO[i]=i;

        for(int i=2; i*i < SITO.length; i++){
            if(SITO[i]==i){
                for(int j = i; j*i< SITO.length; j++){
                    if(SITO[i*j] > i)
                        SITO[i*j]=i;
                }
            }
        }
    }

    public static boolean czyPierwsza (long x){
        if(x<2)
            return false;
        if(x < SITO.length){
            if(SITO[(int)x]==x) return true;
            else return false;
        }
        else 
        for(long i =2; i<SITO.length; i++)
            if(SITO[(int)i]==i)
                if(x%i==0)
                    return false;
				
		long stop = (long)(Math.sqrt(x)/6);		
        for(long k=SITO.length/6L; k<stop; k++){
            if(x%(6*k+1)==0)
                return false;
            if(x%(6*k-1)==0)
                return false;
        }
        return true;
    }

    public static long[] naCzynnikiPierwsze (long x){
        List<Long> czynniki = new ArrayList<Long>(0);
		
		if(x==1 || x==0){
            long c []= new long[1];
            c[0]=x;
            return c;
        }
        if(x<0){
            czynniki.add(-1L);
            x*=-1L;
            if(x<0 && x%2==0){
                    x/=2;
					x*=-1L;
                    czynniki.add(2L);
                }
                
        }
        if(x<SITO.length)
            while(x>1){
                czynniki.add((long)(SITO[(int)x]));
                x=x/((long)(SITO[(int)x]));
            }
        else{            
            for(long i = 2; i<SITO.length; i++)
                if(SITO[(int)i]==i && x%i==0){
                    while(x%i==0){
                        czynniki.add(i);
                        x=x/i;
                    }
                    if(x==1)
                        break;
                }
                
			long stop = (long)(Math.sqrt(x)/6);
			for (long k=SITO.length/6L; k<stop; k++){
				if (x%(6*k+1)==0 || x%(6*k-1)==0){
					while(x%(6*k+1)==0){
						czynniki.add((6*k+1));
      				    x=x/(6*k+1);
      				}
      				while(x%(6*k-1)==0){
						czynniki.add((6*k-1));
						x=x/(6*k-1);
      				}
      				if(x==1)
						break;
     				}
   				}
			
			if(x>1)
				czynniki.add(x);
        }
		long c[]=new long[czynniki.size()];
		for(int i =0; i<c.length; i++)
			c[i]=czynniki.get(i);
		return c;
    }
	
	public static void main(String args[])
	{
		for(int i=0; i<args.length; i++)
        {
            long x=Long.valueOf(args[i]);
			long[] czynnikiPierwsze = LiczbyPierwsze.naCzynnikiPierwsze(x);
            System.out.print(x+" = ");            
			if(czynnikiPierwsze.length==1)
				System.out.println(czynnikiPierwsze[0]);
			else{
                for(int j =0; j<czynnikiPierwsze.length-1; j++)
                    System.out.print(czynnikiPierwsze[j]+"*");
				System.out.println(czynnikiPierwsze[czynnikiPierwsze.length-1]);
			}
        }
		if(args.length<1)
			System.err.println("Nie podano liczby.\nAby rozlozyc liczby na czynniki pierwsze podaj je do programu za pomoca wiersza polecenia.\nObslugiwany zakres: [-2^63 ; 2^63-1]");
    }
}