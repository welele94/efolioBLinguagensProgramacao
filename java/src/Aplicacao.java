import java.util.Scanner;

public class Aplicacao {
    public static void main(String[] args) {
        // Ficheiro Prolog principal do projeto.
        // Foi criado um sistema.pl para evitar confusao entre carregar apenas a base
        // ou apenas as regras. Assim, o Java tem sempre um unico ponto de entrada.
        String ficheiroProlog = args.length > 0 ? args[0] : "prolog/sistema.pl";

        // O Scanner fica aqui para ser partilhado pelo menu durante toda a execucao.
        Scanner scanner = new Scanner(System.in);

        try {
            // O integrador trata da comunicacao com o Prolog via JPL.
            // O menu fica responsavel apenas pela interacao com o utilizador.
            IntegradorProlog integrador = new IntegradorProlog(ficheiroProlog);
            Menu menu = new Menu(scanner, integrador);
            menu.iniciar();
        } catch (Exception e) {
            // Mensagem simples para o utilizador, sem deixar a aplicacao terminar em stack trace.
            System.out.println("Erro ao iniciar a aplicacao: " + e.getMessage());
        } finally {
            scanner.close();
        }
    }
}
