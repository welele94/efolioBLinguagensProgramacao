import java.util.Scanner;

public class Menu {
    private final Scanner scanner;
    private final IntegradorProlog integrador;

    public Menu(Scanner scanner, IntegradorProlog integrador) {
        this.scanner = scanner;
        this.integrador = integrador;
    }

    public void iniciar() {
        boolean ativo = true;
        while (ativo) {
            imprimirOpcoes();
            String opcao = scanner.nextLine().trim();

            try {
                if ("1".equals(opcao)) {
                    imprimirLista("Alunos em risco", integrador.listarEmRisco());
                } else if ("2".equals(opcao)) {
                    imprimirLista("Alunos participativos", integrador.listarParticipativos());
                } else if ("3".equals(opcao)) {
                    imprimirLista("Alunos com bom desempenho", integrador.listarBons());
                } else if ("4".equals(opcao)) {
                    imprimirLista("Alunos acima da media da turma", integrador.listarAcimaMedia());
                } else if ("5".equals(opcao)) {
                    consultarAluno();
                } else if ("6".equals(opcao)) {
                    adicionarAluno();
                } else if ("7".equals(opcao)) {
                    atualizarMedia();
                } else if ("8".equals(opcao)) {
                    atualizarParticipacao();
                } else if ("9".equals(opcao)) {
                    removerAluno();
                } else if ("10".equals(opcao)) {
                    imprimirLista("Alunos em observacao", integrador.listarEmObservacao());
                } else if ("11".equals(opcao)) {
                    imprimir(integrador.mediaTurma());
                } else if ("0".equals(opcao)) {
                    ativo = false;
                } else {
                    System.out.println("Opcao invalida.");
                }
            } catch (Exception e) {
                System.out.println("Erro: " + e.getMessage());
            }
        }
    }

    private void imprimirOpcoes() {
        System.out.println();
        System.out.println("=== Sistema Prolog de Acompanhamento de Turmas ===");
        System.out.println("1 - Listar alunos em risco");
        System.out.println("2 - Listar alunos participativos");
        System.out.println("3 - Listar alunos com bom desempenho");
        System.out.println("4 - Listar alunos acima da media da turma");
        System.out.println("5 - Consultar aluno por ID");
        System.out.println("6 - Adicionar aluno");
        System.out.println("7 - Atualizar media de aluno");
        System.out.println("8 - Atualizar participacao de aluno");
        System.out.println("9 - Remover aluno da base de conhecimento");
        System.out.println("10 - Bonus: listar alunos em observacao");
        System.out.println("11 - Mostrar media da turma");
        System.out.println("0 - Sair");
        System.out.print("Opcao: ");
    }

    private int lerId() {
        System.out.print("ID do aluno: ");
        String texto = scanner.nextLine().trim();
        return Integer.parseInt(texto);
    }

    private double lerDouble(String mensagem) {
        System.out.print(mensagem);
        String texto = scanner.nextLine().trim().replace(',', '.');
        return Double.parseDouble(texto);
    }

    private String lerTexto(String mensagem) {
        System.out.print(mensagem);
        return scanner.nextLine().trim();
    }

    private void consultarAluno() {
        int id = lerId();
        imprimir(integrador.consultarAluno(id));
    }

    private void adicionarAluno() {
        int id = lerId();
        String nome = lerTexto("Nome do aluno: ");
        if (integrador.adicionarAluno(id, nome)) {
            System.out.println("Aluno adicionado e base persistida.");
        } else {
            System.out.println("Nao foi possivel adicionar o aluno. Verifique se o ID ja existe.");
        }
    }

    private void atualizarMedia() {
        int id = lerId();
        double media = lerDouble("Nova media (0 a 20): ");
        if (integrador.atualizarMedia(id, media)) {
            System.out.println("Media atualizada e base persistida.");
        } else {
            System.out.println("Nao foi possivel atualizar a media.");
        }
    }

    private void atualizarParticipacao() {
        int id = lerId();
        int participacoes = Integer.parseInt(lerTexto("Numero de participacoes: "));
        if (integrador.atualizarParticipacao(id, participacoes)) {
            System.out.println("Participacao atualizada e base persistida.");
        } else {
            System.out.println("Nao foi possivel atualizar a participacao.");
        }
    }

    private void removerAluno() {
        int id = lerId();
        String confirmacao = lerTexto("Confirmar remocao? (s/N): ");
        if (!"s".equalsIgnoreCase(confirmacao)) {
            System.out.println("Operacao cancelada.");
            return;
        }

        if (integrador.removerAluno(id)) {
            System.out.println("Aluno removido e base persistida.");
        } else {
            System.out.println("Aluno nao encontrado.");
        }
    }

    private void imprimir(String texto) {
        System.out.println();
        System.out.println(texto);
    }

    private void imprimirLista(String titulo, String lista) {
        System.out.println();
        System.out.println(titulo + ": " + lista);
    }
}
