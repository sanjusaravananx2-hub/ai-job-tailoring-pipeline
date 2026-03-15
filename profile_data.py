"""
Sanjeev Kumar - Structured Profile Data
Used by the CV tailoring engine and cover letter generator.
"""

PROFILE = {
    "name": "Sanjeev Kumar",
    "email": "your-email@example.com",
    "phone": "+44 XXXX XXXXXX",
    "location": "Leeds, United Kingdom",
    "linkedin": "linkedin.com/in/sanjeev-kumarx2",

    "summary": (
        "Embedded Systems Engineer completing an MSc at the University of Leeds "
        "(graduating Sep 2026), with hands-on experience developing real-time "
        "embedded firmware in C/C++ on ARM Cortex-M microcontrollers and embedded "
        "Linux platforms."
    ),

    "education": [
        {
            "degree": "MSc Embedded Systems Engineering",
            "institution": "University of Leeds",
            "dates": "Sep 2025 – Sep 2026",
            "grade": "Predicted First Class",
        },
        {
            "degree": "B.Eng Electronics & Communication Engineering",
            "institution": "Sathyabama Institute of Science & Technology, Chennai",
            "dates": "Aug 2021 – May 2025",
            "grade": "First Class with Distinction",
        },
    ],

    "technical_skills": {
        "languages": ["C", "C++", "Python", "Verilog HDL", "MATLAB/Simulink"],
        "platforms": [
            "ARM Cortex-M (STM32)",
            "Dual-core ARM Cortex-A9 (Cyclone V SoC, Linux)",
            "Pixhawk (PX4/NuttX RTOS)",
        ],
        "protocols": ["CAN 2.0B", "UART", "SPI", "I2C", "AXI4-Lite", "MAVLink", "PWM"],
        "competencies": [
            "Bare-metal & RTOS-based firmware",
            "Interrupt-driven I/O",
            "Peripheral driver development",
            "Register-level configuration",
            "Real-time data acquisition",
            "Hardware-software integration",
            "Embedded debugging",
            "Sensor interfacing",
            "Model-based development",
            "Electrothermal modelling",
            "Control systems",
            "Power electronics",
        ],
        "tools": [
            "STM32CubeIDE", "ARM Development Studio", "Intel Quartus Prime",
            "Git", "MATLAB/Simulink", "SolidWorks",
        ],
    },

    "experience": [
        {
            "title": "Avionics & Propulsion Engineer",
            "company": "Gryphon Arrows (IMechE UAS Challenge)",
            "location": "University of Leeds",
            "dates": "Oct 2025 – Present",
            "bullets": [
                "Designed and integrated Pixhawk (STM32-based, PX4/NuttX RTOS) avionics for an autonomous UAV, covering flight control, telemetry architecture, and multi-sensor interfacing (GPS, IMU, power modules).",
                "Reduced telemetry latency spikes by 40% through MAVLink protocol optimisation and hardware configuration tuning, improving real-time data reliability.",
                "Implemented low-power management strategies and circuit-level optimisations to extend mission endurance.",
            ],
            "keywords": ["UAV", "avionics", "Pixhawk", "PX4", "NuttX", "RTOS", "MAVLink", "telemetry", "GPS", "IMU", "low-power"],
        },
        {
            "title": "Formula Student EV Vehicle Dynamics Engineer",
            "company": "Leeds Gryphon Racing",
            "location": "University of Leeds",
            "dates": "Oct 2025 – Present",
            "bullets": [
                "Contributing to vehicle dynamics analysis, CAN-based telemetry integration, and system-level performance validation for a Formula Student electric vehicle.",
            ],
            "keywords": ["Formula Student", "EV", "CAN", "telemetry", "vehicle dynamics", "electric vehicle"],
        },
        {
            "title": "Embedded Systems Engineer (Industrial Training)",
            "company": "InTrainz",
            "dates": "Feb 2024 – Sep 2024",
            "bullets": [
                "Completed 8-month industrial placement developing embedded firmware in C/C++ for microcontroller-based real-time systems, including peripheral driver development, communication protocol debugging, and hardware-software integration.",
            ],
            "keywords": ["industrial", "firmware", "C/C++", "microcontroller", "real-time", "peripheral driver", "protocol debugging"],
        },
        {
            "title": "Radio Communication Engineer",
            "company": "Leeds Space Communications Group",
            "dates": "Jul 2025 – Present",
            "bullets": [
                "Deployed and tested VHF/UHF antenna systems; performed SWR measurements and RF diagnostics to improve communication link reliability.",
            ],
            "keywords": ["RF", "radio", "antenna", "VHF", "UHF", "communications"],
        },
    ],

    "projects": [
        {
            "title": "AI-Driven Thermal Prediction for EV Inverter Power Modules",
            "type": "MSc Project – Ongoing",
            "tech": "STM32, Embedded C, Python, MATLAB/Simulink",
            "bullets": [
                "Built a coupled electrothermal model in MATLAB for an IGBT power module (10 kHz SPWM, 600 V DC bus, 35 A peak) using a 4-layer Foster RC thermal network with temperature-dependent thermal resistance, validated within ±3–5°C of datasheet references.",
                "Engineered loss-based features (conduction, switching, and diode reverse-recovery losses) from fused sensor telemetry (phase currents, DC-link voltage, PWM duty, coolant temperature), improving prediction stability by 20% over raw-input baselines.",
                "Deploying a lightweight regression model on STM32 via X-CUBE-AI/CMSIS-NN, reducing inference latency by over 95% versus physics-based simulation while enabling real-time thermal protection and active derating.",
            ],
            "keywords": ["EV", "inverter", "IGBT", "thermal", "MATLAB", "Simulink", "AI", "ML", "X-CUBE-AI", "CMSIS-NN", "power electronics", "automotive"],
        },
        {
            "title": "CAN Bus Sensor Fusion Platform",
            "type": "Academic Project",
            "tech": "STM32F4, Cyclone V SoC, Verilog HDL, CAN, SPI, I2C, AXI4-Lite",
            "bullets": [
                "Built a multi-node CAN 2.0B network (500 kbps): STM32F4 bare-metal firmware acquires IMU and environmental data via I2C at 100 Hz and transmits over CAN using an SPI-driven MCP2515 controller.",
                "Designed custom Verilog IP on Cyclone V FPGA (SPI master, CAN frame parser, 8-tap FIR filter), reducing signal-processing latency by 90% versus software-only filtering.",
                "Integrated a Cortex-M4 → FPGA → Cortex-A9 (Linux) data pipeline via AXI4-Lite bridges with hardware timestamping, achieving 35% improvement in sensor data throughput.",
            ],
            "keywords": ["CAN", "SPI", "I2C", "FPGA", "Verilog", "sensor fusion", "AXI4-Lite", "bare-metal", "STM32", "Cyclone V"],
        },
    ],

    "certifications": [
        "UK Amateur Radio Foundation Licence (M7KVD)",
        "Power Electronics – Univ. of Colorado Boulder",
        "EV Sensors – Univ. of Colorado Boulder",
        "MATLAB Onramp – MathWorks",
    ],
}
