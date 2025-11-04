import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import Banner from './Banner';

describe('Banner Component', () => {
  test('renders banner buttons', () => {
    render(<Banner />);
    
    const playButton = screen.getByRole('button', { name: /play/i });
    const myListButton = screen.getByRole('button', { name: /my list/i });
  
    expect(playButton).toBeInTheDocument();
    expect(myListButton).toBeInTheDocument();
  });

  test('renders banner background image', () => {
    const { container } = render(<Banner />);
    const bannerDiv = container.querySelector('.Banner');
  
    expect(bannerDiv).toBeInTheDocument();
    expect(window.getComputedStyle(bannerDiv).backgroundImage).toBeTruthy();
  });
});

