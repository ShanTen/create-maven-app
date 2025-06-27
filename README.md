# Create-maven-app 

A simple powershell script to quickly scaffold a new Maven project with sensible defaults.

## Motivation

I come from a node.js background, where I've grown accustomed to using `npm init` to quickly scaffold a new project. In the Java ecosystem, the equivalent is `mvn archetype:generate`, but I found it a bit cumbersome and not as straightforward as I'd like.

Thus like every single developer with too little time on their hands, I decided to create a simple script that would allow me to quickly scaffold a new Maven project with sensible defaults.

I wanted it to create a json based configuration file (`jpscript.json`) that I could easily edit, and also a general purpose runner script (`jpscript.ps1`) that would allow me to run the project with a single command similar to `npm run start` or `npm run build`.

### Prerequisites
- JDK 
- Maven installed and available in your PATH (not strictly required, but recommended for running Maven commands)

## Usage

### Create a new Maven project

To create a new Maven project, run the `create-maven-app.ps1` script.

```
PS: ~\myCode\Java\test-site> .\create-maven-app.ps1

Enter the name of the Maven project (e.g., My App): This is an example
Enter the artifact ID (e.g., my-app) — do not use spaces: this-is-an-example
Enter the group ID (e.g., com.example): com.example
Enter version (default: 1.0.0): 1.0.0
Creating Maven project...
```
This will create a new Maven project in the current directory with the specified name, artifact ID, group ID, and version. It will also generate a `jpscript.json` file with the project configuration.

### Running jpscripts

```
.\jpscript.ps1 build # Build the project
.\jpscript.ps1 test # Run tests
.\jpscript.ps1 run # Run the project
```
Refer the [demo application]("https://github.com/shanten/create-maven-app/tree/main/demo-application") 
for the complete generated project structure.

### Adding path to your maven installation

Some users may not prefer having Maven in their PATH, or may have multiple versions of Maven installed. In such cases, you can specify the path to your Maven installation by modifying the `$mvnCMDpath` variable in the `create-maven-app.ps1` script.

## To Do
- [ ] Wrap everything in a main module method
- [ ] Fix versioning to use the correct format (e.g., 1.0.0-SNAPSHOT)
- [ ] Add parameters for command line arguments instead of interactive prompts
- [ ] Handle errors gracefully 
- [ ] Add support for creating a multi-module Maven project
- [ ] Add support for creating a SpringBoot project

~ Shantanu Ramanujapuram, 2025