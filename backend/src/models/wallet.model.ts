export interface Wallet {
  id?: string;
  user_id: string;
  type: 'primary' | 'child' | 'agent';
  name?: string;
  balance: number;
  created_at?: Date;
}
