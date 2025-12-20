export const workshops = [
  {
    id: 1,
    name: "Auto Mecânica Silva",
    image: "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?auto=format&fit=crop&w=800&q=80",
    rating: 4.8,
    reviewCount: 124,
    distance: "1.2 km",
    address: "Av. Paulista, 1000 - Bela Vista, São Paulo",
    categories: ["Mecânica Geral", "Troca de Óleo", "Freios"],
    description: "Especialistas em mecânica geral com mais de 20 anos de mercado. Atendemos todas as marcas.",
    services: [
      { id: 1, name: "Troca de Óleo Completa", price: 180.00, duration: "45 min" },
      { id: 2, name: "Alinhamento e Balanceamento", price: 120.00, duration: "1h" },
      { id: 3, name: "Revisão de Freios", price: 250.00, duration: "2h" }
    ],
    reviews: [
      { id: 1, user: "Carlos Eduardo", rating: 5, comment: "Serviço rápido e honesto. Recomendo!", date: "2 dias atrás" },
      { id: 2, user: "Ana Maria", rating: 4, comment: "Bom atendimento, mas demorou um pouco.", date: "1 semana atrás" }
    ]
  },
  {
    id: 2,
    name: "Centro Automotivo Premium",
    image: "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=800&q=80",
    rating: 4.9,
    reviewCount: 89,
    distance: "2.5 km",
    address: "Rua Augusta, 500 - Consolação, São Paulo",
    categories: ["Elétrica", "Ar Condicionado", "Diagnóstico"],
    description: "Tecnologia de ponta para diagnóstico e reparo do seu veículo. Especializados em importados.",
    services: [
      { id: 1, name: "Higienização de Ar Condicionado", price: 150.00, duration: "1h" },
      { id: 2, name: "Diagnóstico Computadorizado", price: 200.00, duration: "1h 30min" }
    ],
    reviews: [
      { id: 1, user: "Roberto Santos", rating: 5, comment: "Resolveram um problema elétrico que ninguém achava.", date: "3 dias atrás" }
    ]
  },
  {
    id: 3,
    name: "Borracharia do Zé",
    image: "https://images.unsplash.com/photo-1530046339160-ce3e530c7d2f?auto=format&fit=crop&w=800&q=80",
    rating: 4.5,
    reviewCount: 210,
    distance: "0.8 km",
    address: "Rua da Consolação, 1200 - Consolação, São Paulo",
    categories: ["Pneus", "Borracharia", "Socorro 24h"],
    description: "Serviço rápido de reparo de pneus e troca. Atendimento 24 horas para emergências.",
    services: [
      { id: 1, name: "Reparo de Pneu", price: 40.00, duration: "20 min" },
      { id: 2, name: "Troca de Pneu", price: 30.00, duration: "30 min" }
    ],
    reviews: [
      { id: 1, user: "Fernanda Lima", rating: 5, comment: "Me salvou no domingo a noite!", date: "1 mês atrás" }
    ]
  },
  {
    id: 4,
    name: "Funilaria Express",
    image: "https://images.unsplash.com/photo-1507136566006-cfc505b114fc?auto=format&fit=crop&w=800&q=80",
    rating: 4.7,
    reviewCount: 56,
    distance: "3.0 km",
    address: "Av. 23 de Maio, 2000 - Vila Mariana, São Paulo",
    categories: ["Funilaria", "Pintura", "Martelinho de Ouro"],
    description: "Recuperamos a estética do seu carro com rapidez e qualidade. Martelinho de ouro sem pintura.",
    services: [
      { id: 1, name: "Martelinho de Ouro (peça)", price: 150.00, duration: "2h" },
      { id: 2, name: "Polimento Cristalizado", price: 350.00, duration: "4h" }
    ],
    reviews: [
      { id: 1, user: "João Paulo", rating: 4, comment: "Ficou como novo, muito bom.", date: "2 semanas atrás" }
    ]
  }
];

export const categories = [
  { id: 'all', name: 'Todos', icon: 'SquaresFour' },
  { id: 'mecanica', name: 'Mecânica', icon: 'Wrench' },
  { id: 'eletrica', name: 'Elétrica', icon: 'Lightning' },
  { id: 'oleo', name: 'Troca de Óleo', icon: 'Drop' },
  { id: 'freios', name: 'Freios', icon: 'Disc' },
];
