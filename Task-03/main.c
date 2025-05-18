#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

struct String {
	char* chars;
	size_t len;
};

char **args = NULL;

void delete(struct String str)
{
	free(str.chars);
}

void output_prompt() {
	printf(">> ");
}

struct String input_line() {
	struct String str;
	str.len = 0;
	str.chars = NULL;

	if (getline(&str.chars, &str.len, stdin) == -1) {
		if (str.chars) free(str.chars);
        str.chars = NULL;
	}
	
	return str;
}

void output_line(char* line) {
	printf("%s", line);
}

int main(int argc, char* argv[])
{
	while (1)
	{
		int tokenId = 0;
		output_prompt();
		struct String command = input_line();

		if (command.chars == NULL) continue;

		char *token = strtok(command.chars, " \n");


		while (token != NULL)
		{
			args = realloc(args, sizeof(char*) * (tokenId + 1));
			args[tokenId] = token;
			tokenId++;
			token = strtok(NULL, " \n");
		}

		args = realloc(args, sizeof(char*) * (tokenId + 1));
		args[tokenId] = NULL;

		if (args[0] == NULL)
		{
            delete(command);
            continue;
        }

		if (strcmp(args[0], "exit") == 0)
		{
			delete(command);
            free(args);
			break;
		}

		if (strcmp(args[0], "cd") == 0)
		{
			if (args[1] == NULL) {
				printf("Invalid input\n");
			} else {
				if (chdir(args[1]) != 0) {
					perror("Invalid path");
				} else {
					delete(command);
					continue;
				}
			}
		}

		pid_t proc = fork();

		if (proc == 0) {
			execvp(args[0], args);
			perror("execvp failed");
		} else {
			wait(NULL);
		}

		delete(command);

		// free(args);
	}

	return 0;
}