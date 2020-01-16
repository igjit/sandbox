# kotlin-for-py

[Migrating from Python](https://kotlinlang.org/docs/tutorials/kotlin-for-py/introduction.html)

## Installation

### Compiler

[Working with the Command Line Compiler](https://kotlinlang.org/docs/tutorials/command-line.html)

On Ubuntu 18.04:

```sh
sudo snap install --classic kotlin
```

On Mac:

```sh
curl -s https://get.sdkman.io | bash
. ~/.bash_profile
sdk install kotlin
sdk install java
```

### Emacs

[kotlin-mode](https://github.com/Emacs-Kotlin-Mode-Maintainers/kotlin-mode)

```el
M-x package-install [RET] kotlin-mode [RET]
```

For SDKMAN:

```sh
cp kotlinc.sh ~/bin/
```

```el
(add-to-list 'exec-path "~/bin/")
(defun my-kotlin-mode-setup ()
  (setq-local kotlin-command "kotlinc.sh"))
(add-hook 'kotlin-mode-hook 'my-kotlin-mode-setup)
```
