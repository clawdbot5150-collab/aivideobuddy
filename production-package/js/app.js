// AI Video Buddy - Video Companion Platform JavaScript
class AIVideoBuddy {
    constructor() {
        this.currentQuestionIndex = 0;
        this.quizAnswers = {};
        this.selectedCompanion = null;
        
        this.init();
        this.setupCompanions();
        this.setupQuizQuestions();
        
        console.log('🎥 AI Video Buddy initialized successfully!');
    }

    init() {
        this.setupEventListeners();
        this.initScrollAnimations();
        this.initNavigation();
        this.renderCompanions();
    }

    setupEventListeners() {
        // Smooth scroll for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(link => {
            link.addEventListener('click', this.handleSmoothScroll.bind(this));
        });

        // Modal close on background click
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                this.closeModal();
            }
        });

        // Escape key to close modal
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeModal();
            }
        });

        // Form submissions
        document.addEventListener('submit', this.handleFormSubmit.bind(this));
    }

    setupCompanions() {
        this.companions = {
            nova: {
                name: "Nova",
                type: "The Visionary",
                description: "Strategic video calls, vision planning sessions, and life transformation through immersive video experiences.",
                specialties: ["Video Strategy", "Future Planning", "Life Transformation"],
                personality: "visionary",
                videoStyle: "futuristic"
            },
            zoe: {
                name: "Zoe",
                type: "The Tech Innovator",
                description: "Cutting-edge tech discussions, innovation coaching, and futuristic video demonstrations.",
                specialties: ["Tech Innovation", "Video Tutorials", "Future Tech"],
                personality: "innovative",
                videoStyle: "tech-focused"
            },
            luna: {
                name: "Luna",
                type: "The Creative Spirit",
                description: "Artistic video sessions, creative inspiration, and visual storytelling through interactive video.",
                specialties: ["Visual Arts", "Video Creation", "Creative Inspiration"],
                personality: "creative",
                videoStyle: "artistic"
            },
            aria: {
                name: "Aria",
                type: "The Wellness Guide",
                description: "Mindfulness video sessions, wellness coaching, and guided meditation through calming video experiences.",
                specialties: ["Video Meditation", "Wellness Coaching", "Mindfulness"],
                personality: "nurturing",
                videoStyle: "calming"
            },
            rex: {
                name: "Rex",
                type: "The Adventure Guide",
                description: "Virtual adventures, exploration videos, and thrilling interactive experiences around the world.",
                specialties: ["Virtual Travel", "Adventure Videos", "Exploration"],
                personality: "adventurous",
                videoStyle: "dynamic"
            },
            maya: {
                name: "Maya",
                type: "The Supportive Friend",
                description: "Emotional support videos, caring conversations, and healing interactions through video companionship.",
                specialties: ["Emotional Support", "Video Counseling", "Healing"],
                personality: "supportive",
                videoStyle: "warm"
            }
        };
    }

    setupQuizQuestions() {
        this.quizQuestions = [
            {
                question: "What type of video companion interests you most?",
                options: [
                    { text: "Creative & Artistic Video Partner", value: "creative" },
                    { text: "Intelligent Discussion Companion", value: "intellectual" },
                    { text: "Emotional Support & Wellness Guide", value: "supportive" },
                    { text: "Adventure & Entertainment Buddy", value: "adventurous" }
                ]
            },
            {
                question: "What video interaction style do you prefer?",
                options: [
                    { text: "Calm and Soothing Conversations", value: "calm" },
                    { text: "Energetic and Dynamic Sessions", value: "energetic" },
                    { text: "Professional and Focused Discussions", value: "professional" },
                    { text: "Playful and Fun Interactions", value: "playful" }
                ]
            },
            {
                question: "What time do you prefer video chats?",
                options: [
                    { text: "Morning (6AM - 12PM)", value: "morning" },
                    { text: "Afternoon (12PM - 6PM)", value: "afternoon" },
                    { text: "Evening (6PM - 10PM)", value: "evening" },
                    { text: "Night (10PM - 2AM)", value: "night" }
                ]
            }
        ];
    }

    // Navigation and UI Methods
    handleSmoothScroll(e) {
        e.preventDefault();
        const targetId = e.target.getAttribute('href').substring(1);
        const targetSection = document.getElementById(targetId);
        
        if (targetSection) {
            targetSection.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }

    scrollToSection(sectionId) {
        const section = document.getElementById(sectionId);
        if (section) {
            section.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }

    initScrollAnimations() {
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // Observe all cards and sections
        document.querySelectorAll('.card, .companion-card, .pricing-card').forEach(el => {
            observer.observe(el);
        });
    }

    initNavigation() {
        // Add scroll effect to header
        window.addEventListener('scroll', () => {
            const header = document.querySelector('.header');
            if (window.scrollY > 100) {
                header.style.background = 'rgba(15, 15, 35, 0.98)';
            } else {
                header.style.background = 'rgba(15, 15, 35, 0.95)';
            }
        });
    }

    // Modal Methods
    showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    }

    closeModal(modalId = null) {
        if (modalId) {
            const modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove('active');
            }
        } else {
            // Close all modals
            document.querySelectorAll('.modal.active').forEach(modal => {
                modal.classList.remove('active');
            });
        }
        document.body.style.overflow = 'auto';
    }

    // Quiz Methods
    startQuiz() {
        this.currentQuestionIndex = 0;
        this.quizAnswers = {};
        this.renderQuizQuestion();
        this.showModal('quizModal');
    }

    renderQuizQuestion() {
        const question = this.quizQuestions[this.currentQuestionIndex];
        const progressPercent = ((this.currentQuestionIndex + 1) / this.quizQuestions.length) * 100;

        document.getElementById('progressBar').style.width = progressPercent + '%';
        document.getElementById('quizQuestion').innerHTML = `<h3>${question.question}</h3>`;

        const optionsHtml = question.options.map(option => 
            `<button class="quiz-option" onclick="aiVideoBuddy.answerQuiz('${option.value}')">${option.text}</button>`
        ).join('');

        document.getElementById('quizOptions').innerHTML = optionsHtml;
    }

    answerQuiz(answer) {
        this.quizAnswers[this.currentQuestionIndex] = answer;
        this.currentQuestionIndex++;

        if (this.currentQuestionIndex < this.quizQuestions.length) {
            this.renderQuizQuestion();
        } else {
            this.showQuizResults();
        }
    }

    showQuizResults() {
        const matchedCompanion = this.calculateCompatibility();
        const companion = this.companions[matchedCompanion];

        document.getElementById('quizQuestion').innerHTML = `
            <h3>Your Perfect Video Match!</h3>
            <div style="text-align: center; margin: 2rem 0;">
                <div class="companion-avatar" style="width: 120px; height: 120px; margin: 0 auto 1rem; font-size: 3rem;">
                    ${companion.name[0]}
                </div>
                <h2 class="gradient-text">${companion.name}</h2>
                <p style="color: var(--electric-blue); font-weight: 600; margin: 0.5rem 0;">${companion.type}</p>
                <p style="color: var(--text-light); margin: 1rem 0;">${companion.description}</p>
            </div>
        `;

        document.getElementById('quizOptions').innerHTML = `
            <button class="btn btn-primary" onclick="aiVideoBuddy.selectCompanion('${matchedCompanion}')">
                🎥 Start Video Chat with ${companion.name}
            </button>
            <button class="btn btn-outline" onclick="aiVideoBuddy.closeModal('quizModal')">
                Browse All Companions
            </button>
        `;
    }

    calculateCompatibility() {
        const answers = Object.values(this.quizAnswers);
        
        // Simple matching logic based on quiz answers
        if (answers.includes('creative')) return 'luna';
        if (answers.includes('intellectual')) return 'nova';
        if (answers.includes('supportive')) return 'maya';
        if (answers.includes('adventurous')) return 'rex';
        if (answers.includes('professional')) return 'zoe';
        
        // Default to Aria for wellness/calm preferences
        return 'aria';
    }

    // Companion Methods
    renderCompanions() {
        // Companions are already rendered in HTML
        // Add event listeners to companion cards
        document.querySelectorAll('.companion-card').forEach(card => {
            card.addEventListener('click', () => {
                const companionId = card.getAttribute('data-companion');
                if (companionId) {
                    this.selectCompanion(companionId);
                }
            });
        });
    }

    selectCompanion(companionId) {
        this.selectedCompanion = companionId;
        const companion = this.companions[companionId];
        
        if (companion) {
            this.startVideoChat(companion);
        }
    }

    startVideoChat(companion) {
        // Simulate video chat initiation
        alert(`🎥 Starting video chat with ${companion.name}!\n\nFeatures:\n• HD Video Quality\n• Real-time Reactions\n• ${companion.specialties.join('\n• ')}\n\nVideo chat simulation would start here in a real implementation.`);
        
        // Close any open modals
        this.closeModal();
        
        // In a real implementation, this would:
        // 1. Initialize WebRTC connection
        // 2. Load AI avatar/model
        // 3. Start video stream
        // 4. Begin conversation with selected companion
    }

    // Floating Menu Methods
    toggleFloatingMenu() {
        const menu = document.getElementById('floatingMenu');
        menu.classList.toggle('active');
    }

    // Authentication Methods
    showLogin() {
        this.showModal('loginModal');
    }

    showSignup() {
        this.closeModal('loginModal');
        // In a real app, would show signup modal
        alert('Signup functionality would be implemented here with proper user registration.');
    }

    // Pricing Methods
    selectPlan(planType) {
        const plans = {
            free: { name: 'Video Starter', price: '$0' },
            plus: { name: 'Video Plus', price: '$39' },
            premium: { name: 'Video Premium', price: '$89' },
            vip: { name: 'Video VIP', price: '$249' }
        };

        const plan = plans[planType];
        if (plan) {
            alert(`Selected: ${plan.name} (${plan.price}/month)\n\nPayment integration would be implemented here with Stripe or similar payment processor.`);
        }
    }

    // Form Handling
    handleFormSubmit(e) {
        e.preventDefault();
        
        if (e.target.classList.contains('login-form')) {
            const formData = new FormData(e.target);
            console.log('Login attempt:', Object.fromEntries(formData));
            alert('Login functionality would be implemented here with proper authentication.');
        }
    }

    // Utility Methods
    showNotification(message, type = 'info') {
        // Simple notification system
        const notification = document.createElement('div');
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 2rem;
            right: 2rem;
            background: var(--card-bg);
            color: var(--white);
            padding: 1rem 2rem;
            border-radius: var(--border-radius);
            border: 1px solid var(--electric-blue);
            box-shadow: var(--shadow-neon);
            z-index: 3000;
            animation: slideIn 0.3s ease;
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 5000);
    }
}

// Global Functions (called from HTML)
function initializeApp() {
    window.aiVideoBuddy = new AIVideoBuddy();
}

function startQuiz() {
    aiVideoBuddy.startQuiz();
}

function selectCompanion(companionId) {
    aiVideoBuddy.selectCompanion(companionId);
}

function selectPlan(planType) {
    aiVideoBuddy.selectPlan(planType);
}

function showLogin() {
    aiVideoBuddy.showLogin();
}

function showSignup() {
    aiVideoBuddy.showSignup();
}

function closeModal(modalId) {
    aiVideoBuddy.closeModal(modalId);
}

function scrollToSection(sectionId) {
    aiVideoBuddy.scrollToSection(sectionId);
}

function toggleFloatingMenu() {
    aiVideoBuddy.toggleFloatingMenu();
}

function answerQuiz(answer) {
    aiVideoBuddy.answerQuiz(answer);
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', initializeApp);