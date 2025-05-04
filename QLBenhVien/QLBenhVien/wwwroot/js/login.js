document.addEventListener('DOMContentLoaded', function () {
    const passwordField = document.querySelector('input[type="password"]');
    const toggleButton = document.getElementById('togglePassword');

    toggleButton.addEventListener('click', function () {
        const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordField.setAttribute('type', type);
        this.classList.toggle('bi-eye');
        this.classList.toggle('bi-eye-slash');
    });
});
