import java.util.Scanner;

public class Aplicacao {
    public static void main(String[] args) {
        String ficheiroProlog = args.length > 0 ? args[0] : "sistema.pl";

        Scanner scanner = new Scanner(System.in);

        try {
            IntegradorProlog integrador = new IntegradorProlog(ficheiroProlog);
            Menu menu = new Menu(scanner, integrador);
            menu.iniciar();
        } catch (Exception e) {
            System.out.println("Erro ao iniciar a aplicacao: " + e.getMessage());
        } finally {
            scanner.close();
        }
    }
}
