/**
 * GitHub Actions JavaScript Demo
 * ================================
 * 
 * This is a JavaScript action that demonstrates how to:
 * 1. Use @actions/core for inputs, outputs, and logging
 * 2. Use @actions/github for accessing GitHub context
 * 3. Implement custom logic in Node.js
 * 4. Handle errors properly
 * 
 * JavaScript actions run directly on the runner (no container overhead)
 * and have full access to the Node.js ecosystem via npm packages.
 */

// Import the GitHub Actions toolkit
// @actions/core provides functions for inputs, outputs, logging, and more
const core = require('@actions/core');

// @actions/github provides access to the GitHub API and context
const github = require('@actions/github');

/**
 * Main function - entry point for the action
 * 
 * Why async? Because we might need to make API calls or perform
 * asynchronous operations. Always use try/catch for proper error handling!
 */
async function run() {
  try {
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 📚 EDUCATIONAL SECTION: Understanding JavaScript Actions
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('🎓 JAVASCRIPT ACTION: What\'s happening?');
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('');
    core.info('✨ This is a JAVASCRIPT ACTION - powered by Node.js!');
    core.info('');
    core.info('📚 Key Concepts:');
    core.info('   • Runs directly on the workflow runner (Ubuntu, Windows, or macOS)');
    core.info('   • No container overhead = faster startup');
    core.info('   • Full access to npm ecosystem (thousands of packages!)');
    core.info('   • Can use @actions/core for GitHub Actions integration');
    core.info('   • Can use @actions/github for GitHub API access');
    core.info('   • Perfect for complex logic and data processing');
    core.info('');
    core.info('🔍 Why use JavaScript actions?');
    core.info('   • Need complex logic or algorithms');
    core.info('   • Want to use npm packages (axios, lodash, etc.)');
    core.info('   • Need to interact with GitHub API');
    core.info('   • Want fast execution without container overhead');
    core.info('   • Need cross-platform compatibility');
    core.info('');
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 📥 READING INPUTS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    // Get inputs defined in action.yml
    // The second parameter is optional config: { required: true/false, trimWhitespace: true/false }
    const inputText = core.getInput('input-text', { required: true });
    const operationType = core.getInput('operation-type', { required: false }) || 'analyze';
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('📥 Inputs received:');
    core.info(`   input-text: "${inputText}"`);
    core.info(`   operation-type: "${operationType}"`);
    core.info('');
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🌐 ACCESSING GITHUB CONTEXT
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    // The context object contains information about the workflow run
    const { context } = github;
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('🌐 GitHub Context Information:');
    core.info(`   Repository: ${context.repo.owner}/${context.repo.repo}`);
    core.info(`   Event: ${context.eventName}`);
    core.info(`   Workflow: ${context.workflow}`);
    core.info(`   Actor: ${context.actor}`);
    core.info(`   SHA: ${context.sha.substring(0, 7)}`);
    core.info(`   Ref: ${context.ref}`);
    core.info('');
    
    // Log additional context as debug (only shown if ACTIONS_STEP_DEBUG is set to true)
    core.debug(`Full context payload: ${JSON.stringify(context.payload, null, 2)}`);
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🔧 PERFORMING CUSTOM LOGIC
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('🔧 Performing text analysis...');
    core.info('');
    
    // Demonstrate different types of operations based on input
    let result;
    let metadata;
    
    switch (operationType.toLowerCase()) {
      case 'analyze':
        result = analyzeText(inputText);
        core.info('📊 Analysis Results:');
        core.info(`   Characters: ${result.charCount}`);
        core.info(`   Words: ${result.wordCount}`);
        core.info(`   Lines: ${result.lineCount}`);
        core.info(`   Unique Words: ${result.uniqueWords}`);
        metadata = { type: 'analysis', ...result };
        break;
        
      case 'transform':
        result = transformText(inputText);
        core.info('🔄 Transformation Results:');
        core.info(`   Uppercase: ${result.uppercase}`);
        core.info(`   Lowercase: ${result.lowercase}`);
        core.info(`   Reversed: ${result.reversed}`);
        metadata = { type: 'transformation', ...result };
        break;
        
      case 'validate':
        result = validateText(inputText);
        core.info('✅ Validation Results:');
        core.info(`   Valid: ${result.isValid}`);
        core.info(`   Issues: ${result.issues.join(', ') || 'None'}`);
        metadata = { type: 'validation', ...result };
        break;
        
      default:
        core.warning(`Unknown operation type: ${operationType}. Defaulting to 'analyze'.`);
        result = analyzeText(inputText);
        metadata = { type: 'analysis', ...result };
    }
    
    core.info('');
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 📤 SETTING OUTPUTS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    // Set outputs that can be used by subsequent steps
    // Format: core.setOutput('output-name', value)
    core.setOutput('processed-text', JSON.stringify(result));
    core.setOutput('operation-type', operationType);
    core.setOutput('timestamp', new Date().toISOString());
    core.setOutput('metadata', JSON.stringify(metadata));
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('📤 Outputs set:');
    core.info('   ✓ processed-text');
    core.info('   ✓ operation-type');
    core.info('   ✓ timestamp');
    core.info('   ✓ metadata');
    core.info('');
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 🎯 DEMONSTRATING LOGGING LEVELS
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('📝 Demonstrating Logging Levels:');
    core.info('');
    
    // Different log levels for different purposes
    core.debug('This is a debug message (only visible if ACTIONS_STEP_DEBUG=true)');
    core.info('ℹ️  This is an info message (default, always visible)');
    core.notice('📢 This is a notice (creates an annotation)');
    core.warning('⚠️  This is a warning (creates a warning annotation)');
    // core.error() creates an error annotation but doesn't stop execution
    // core.setFailed() sets the action status to failed and stops execution
    
    core.info('');
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // ✅ SUCCESS!
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('✅ JavaScript Action Complete!');
    core.info('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    core.info('');
    core.info('💡 What you learned:');
    core.info('   ✓ How to read inputs with core.getInput()');
    core.info('   ✓ How to access GitHub context with github.context');
    core.info('   ✓ How to implement custom JavaScript logic');
    core.info('   ✓ How to set outputs with core.setOutput()');
    core.info('   ✓ How to use different logging levels');
    core.info('');
    core.info('🎯 Next: Check out the Docker action for containerized execution!');
    core.info('');
    
  } catch (error) {
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // ❌ ERROR HANDLING
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    // setFailed() marks the action as failed and logs the error
    // Always include error.message and optionally error.stack for debugging
    core.setFailed(`Action failed with error: ${error.message}`);
    
    // Log the full error for debugging (only if needed)
    if (error.stack) {
      core.debug(`Stack trace: ${error.stack}`);
    }
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🛠️ HELPER FUNCTIONS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/**
 * Analyzes text and returns statistics
 * @param {string} text - The text to analyze
 * @returns {object} Analysis results
 */
function analyzeText(text) {
  const lines = text.split('\n');
  const words = text.split(/\s+/).filter(word => word.length > 0);
  const uniqueWords = new Set(words.map(w => w.toLowerCase())).size;
  
  return {
    charCount: text.length,
    wordCount: words.length,
    lineCount: lines.length,
    uniqueWords: uniqueWords,
    avgWordLength: words.length > 0 
      ? (words.reduce((sum, word) => sum + word.length, 0) / words.length).toFixed(2)
      : 0
  };
}

/**
 * Transforms text in various ways
 * @param {string} text - The text to transform
 * @returns {object} Transformed text variations
 */
function transformText(text) {
  return {
    uppercase: text.toUpperCase(),
    lowercase: text.toLowerCase(),
    reversed: text.split('').reverse().join(''),
    capitalized: text.split(' ').map(word => 
      word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()
    ).join(' ')
  };
}

/**
 * Validates text based on simple rules
 * @param {string} text - The text to validate
 * @returns {object} Validation results
 */
function validateText(text) {
  const issues = [];
  
  if (text.length === 0) {
    issues.push('Text is empty');
  }
  if (text.length > 1000) {
    issues.push('Text is too long (>1000 chars)');
  }
  if (!/[a-zA-Z]/.test(text)) {
    issues.push('No alphabetic characters found');
  }
  
  return {
    isValid: issues.length === 0,
    issues: issues,
    textLength: text.length
  };
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🚀 RUN THE ACTION
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// Execute the main function
// This is the entry point when the action runs
run();
