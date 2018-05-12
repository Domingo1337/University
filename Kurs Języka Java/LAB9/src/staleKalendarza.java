public class staleKalendarza {
    private static int dniMiesiaca[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    public static int ileDni(int miesiac, int rok){
        if(miesiac == 1){
            if (rok % 400 == 0) return 29;
            else if (rok % 4 == 0 && rok % 100 == 0) return 28;
            else if (rok % 4 == 0) return 29;
            return 28;
        }else if(rok==1582 && miesiac==9) {
            return 21;
        }else return dniMiesiaca[miesiac];

    }
    public static String dzienTygodznie(int dzien){
        return dni[dzien-1];
    }
    public static final String[] miesiace = {"Styczeń", "Luty", "Marzec", "Kwiecień", "Maj", "Czerwiec", "Lipiec", "Sierpień", "Wrzesień", "Październik", "Listopad", "Grudzień"};
    public static final String[] dni = {"Niedziela", "Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek",  "Sobota", };
}
