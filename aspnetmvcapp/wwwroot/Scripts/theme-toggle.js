/**
 * Theme Toggle Script
 * Provides dark mode toggle functionality with localStorage persistence
 */

(function() {
    'use strict';

    const THEME_KEY = 'user-theme-preference';
    const LIGHT_THEME = 'light';
    const DARK_THEME = 'dark';

    /**
     * Initialize theme on page load
     */
    function initTheme() {
        // Check for saved theme preference or default to system preference
        const savedTheme = localStorage.getItem(THEME_KEY);
        const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        const initialTheme = savedTheme || (systemPrefersDark ? DARK_THEME : LIGHT_THEME);
        
        setTheme(initialTheme, false);
    }

    /**
     * Set the theme
     * @param {string} theme - Theme to set ('light' or 'dark')
     * @param {boolean} updateIcon - Whether to update the icon (default: true)
     */
    function setTheme(theme, updateIcon = true) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem(THEME_KEY, theme);
        
        if (updateIcon) {
            updateToggleIcon(theme);
        }
    }

    /**
     * Update the toggle button icon based on current theme
     * @param {string} theme - Current theme
     */
    function updateToggleIcon(theme) {
        const lightIcon = document.getElementById('theme-toggle-light-icon');
        const darkIcon = document.getElementById('theme-toggle-dark-icon');
        
        if (lightIcon && darkIcon) {
            if (theme === DARK_THEME) {
                lightIcon.classList.add('d-none');
                darkIcon.classList.remove('d-none');
            } else {
                lightIcon.classList.remove('d-none');
                darkIcon.classList.add('d-none');
            }
        }
    }

    /**
     * Toggle between light and dark themes
     */
    function toggleTheme() {
        const currentTheme = document.documentElement.getAttribute('data-theme');
        const newTheme = currentTheme === DARK_THEME ? LIGHT_THEME : DARK_THEME;
        setTheme(newTheme);
    }

    /**
     * Setup event listeners
     */
    function setupEventListeners() {
        const toggleButton = document.getElementById('theme-toggle');
        
        if (toggleButton) {
            // Click event
            toggleButton.addEventListener('click', toggleTheme);
            
            // Keyboard support
            toggleButton.addEventListener('keydown', function(event) {
                // Support Enter and Space keys
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    toggleTheme();
                }
            });
        }

        // Listen for system theme changes
        const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
        darkModeMediaQuery.addEventListener('change', function(e) {
            // Only update if user hasn't set a preference
            if (!localStorage.getItem(THEME_KEY)) {
                const newTheme = e.matches ? DARK_THEME : LIGHT_THEME;
                setTheme(newTheme);
            }
        });
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            initTheme();
            setupEventListeners();
        });
    } else {
        initTheme();
        setupEventListeners();
    }

    // Update icon after initialization to prevent FOUC
    window.addEventListener('load', function() {
        const currentTheme = document.documentElement.getAttribute('data-theme') || LIGHT_THEME;
        updateToggleIcon(currentTheme);
    });
})();
