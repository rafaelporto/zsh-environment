# PATH
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
export PATH="/usr/bin:$PATH"
[[ -d /snap/bin ]] && export PATH="/snap/bin:$PATH"
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$HOME/bin/scripts:$PATH"
  export PATH="$HOME/bin/scripts/string-utils:$PATH"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
export PATH="$PATH:$HOME/.dotnet/tools"

# Android SDK
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/emulator"
  export PATH="$PATH:$ANDROID_HOME/platform-tools"
  export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
fi

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Java
if [[ "$OSTYPE" == "darwin"* ]]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"  # MacPorts
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  for _jvm in \
    "/usr/lib/jvm/default-java" \
    "/usr/lib/jvm/java-21-openjdk-arm64" \
    "/usr/lib/jvm/java-21-openjdk-amd64" \
    "/usr/lib/jvm/java-21-openjdk"; do
    [[ -d "$_jvm" ]] && { export JAVA_HOME="$_jvm"; break; }
  done
  unset _jvm
fi
[[ -n "${JAVA_HOME:-}" ]] && export PATH="$JAVA_HOME/bin:$PATH"

# Coursier
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi

# Leiningen
export LEIN_JVM_OPTS="-Daether.dependencyCollector.impl=bf"
