// Example JavaScript code to test Snyk code scan
function greet() {
    let name = prompt("Enter your name:");
    // Potential XSS if name is malicious
    document.body.innerHTML += "<p>Hello, " + name + "!</p>";
}

// Unsafe eval example for Snyk detection
function unsafeEval() {
    let code = "console.log('Running eval')";
    eval(code);
}
