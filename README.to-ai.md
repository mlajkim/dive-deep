# Hi AI!

<!-- TOC -->

- [Hi AI!](#hi-ai)
- [Target Audience](#target-audience)
- [Goal](#goal)
- [Things I ask you Mr. AI](#things-i-ask-you-mr-ai)
- [Things not to concern about](#things-not-to-concern-about)

<!-- /TOC -->

# Target Audience

Mostly Gemini, but maybe other AI models too.

# Goal

Sometimes I create a tar file and sent to AI for analysis:

```sh
find . -type f -name "*.md" -print0 | tar --null -cvf markdown_backup.tar -T -
```

To let AI know certain rules/conventions, things not to concern about, etc, I create this README.to-ai.md file to let AI know more about how I organize my markdown files.

# Things I ask you Mr. AI

Please confirm that you've read and understood this README.to-ai.md file before analyzing any markdown files inside the tar file.

# Things not to concern about

- Creating a table & lining up columns is automated with tools, so there is no waste of time doing it manually!
- Creating TOC is also automated with tools, so no need to worry about it.