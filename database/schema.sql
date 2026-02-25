-- Portfolio Database Schema

-- Profiles table for personal information
CREATE TABLE profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  title VARCHAR(255),
  bio TEXT,
  image_url TEXT,
  github_url TEXT,
  linkedin_url TEXT,
  email VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Skills table for technical skills
CREATE TABLE skills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL, -- frontend, backend, tools, etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects table for portfolio projects
CREATE TABLE projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  image_url TEXT,
  github_url TEXT,
  live_url TEXT,
  featured BOOLEAN DEFAULT FALSE,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Project skills junction table (many-to-many relationship)
CREATE TABLE project_skills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  skill_id UUID REFERENCES skills(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(project_id, skill_id)
);

-- Contact messages table
CREATE TABLE contact_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Chat logs table (for future AI functionality)
CREATE TABLE chat_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id VARCHAR(255) NOT NULL,
  user_message TEXT NOT NULL,
  ai_response TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (Row Level Security)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_logs ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR SELECT USING (true);
CREATE POLICY "Public skills are viewable by everyone" ON skills FOR SELECT USING (true);
CREATE POLICY "Public projects are viewable by everyone" ON projects FOR SELECT USING (true);
CREATE POLICY "Public project skills are viewable by everyone" ON project_skills FOR SELECT USING (true);

-- Policy for inserting contact messages
CREATE POLICY "Anyone can insert contact messages" ON contact_messages FOR INSERT WITH CHECK (true);

-- Policy for inserting chat logs
CREATE POLICY "Anyone can insert chat logs" ON chat_logs FOR INSERT WITH CHECK (true);

-- Insert sample data
INSERT INTO profiles (name, title, bio, email) VALUES 
('John Doe', 'Full Stack Developer', 'Passionate developer with expertise in modern web technologies.', 'john.doe@example.com');

INSERT INTO skills (name, category) VALUES 
('JavaScript', 'frontend'),
('React', 'frontend'),
('Next.js', 'frontend'),
('Node.js', 'backend'),
('PostgreSQL', 'backend'),
('TailwindCSS', 'frontend');

INSERT INTO projects (title, description, featured, order_index) VALUES 
('Portfolio Website', 'A modern portfolio website built with Next.js and TailwindCSS', true, 1),
('E-commerce Platform', 'Full-stack e-commerce solution with payment integration', true, 2),
('Task Management App', 'Collaborative task management tool with real-time updates', false, 3);

-- Link projects with skills
INSERT INTO project_skills (project_id, skill_id) 
SELECT p.id, s.id FROM projects p, skills s 
WHERE p.title = 'Portfolio Website' AND s.name IN ('JavaScript', 'React', 'Next.js', 'TailwindCSS');

INSERT INTO project_skills (project_id, skill_id) 
SELECT p.id, s.id FROM projects p, skills s 
WHERE p.title = 'E-commerce Platform' AND s.name IN ('JavaScript', 'Node.js', 'PostgreSQL');
