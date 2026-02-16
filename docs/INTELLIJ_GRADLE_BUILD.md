# IntelliJ IDEA Gradle Build Configuration

## Overview

IntelliJ IDEA is now configured to use **Gradle for building** instead of its internal build system. This ensures consistency between command-line builds and IDE builds.

## Configuration Files

The following files have been added to `.idea/` to enable Gradle builds:

### `.idea/gradle.xml`
Configures IntelliJ to:
- **Delegate build to Gradle** (`delegatedBuild = true`)
- **Use Gradle for running tests** (`testRunner = GRADLE`)
- Use the Gradle wrapper (`distributionType = DEFAULT_WRAPPED`)
- Use Java 25 JDK (`gradleJvm = openjdk-25`)

### `.idea/compiler.xml`
Sets the bytecode target level to Java 25 for consistency with the Gradle configuration.

## What This Means

### ✅ Benefits
- **Consistent builds**: IDE builds use the same process as `gradlew.bat build`
- **Same dependencies**: IDE uses Gradle's dependency resolution
- **No drift**: Build configuration is centralized in `build.gradle`
- **Team consistency**: All developers get the same build behavior

### 🔧 IntelliJ Build Actions
When you click "Build Project" or run tests in IntelliJ, it will:
1. Use Gradle wrapper (`gradlew.bat`)
2. Execute Gradle tasks (`compileJava`, `test`, etc.)
3. Output to `build/` directory (not `out/`)

## Verifying the Configuration

### Check Build Output Directory
- **Gradle build**: Output goes to `build/classes/java/main/`
- **IntelliJ internal build**: Output would go to `out/production/`

If you see `build/` being used, Gradle delegation is working correctly.

### Check in IntelliJ Settings
1. Go to **File → Settings → Build, Execution, Deployment → Build Tools → Gradle**
2. Verify:
   - **Build and run using**: Gradle
   - **Run tests using**: Gradle
   - **Gradle JVM**: openjdk-25

## Git Status

These configuration files are committed to the repository:
```
.idea/gradle.xml     ✅ Committed (shared team config)
.idea/compiler.xml   ✅ Committed (shared team config)
```

## Team Benefits

When team members clone the repository and open it in IntelliJ:
1. ✅ IntelliJ automatically detects it's a Gradle project
2. ✅ Builds are delegated to Gradle automatically
3. ✅ Tests run through Gradle
4. ✅ Consistent behavior across all developers

## Troubleshooting

### IntelliJ Still Uses Internal Build

**Solution**: 
1. Go to **File → Settings → Build, Execution, Deployment → Build Tools → Gradle**
2. Under "Build and run using" select **Gradle (Default)**
3. Under "Run tests using" select **Gradle (Default)**
4. Click **Apply** and **OK**

### Gradle Daemon Issues

If builds are slow, stop the Gradle daemon:
```cmd
gradlew.bat --stop
```

Then rebuild in IntelliJ.

## References

- [IntelliJ IDEA Gradle Documentation](https://www.jetbrains.com/help/idea/gradle.html)
- [Gradle Tooling API](https://docs.gradle.org/current/userguide/third_party_integration.html)
