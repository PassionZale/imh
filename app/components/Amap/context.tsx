"use client";

import { User } from "@/app/interfaces";
import { createContext } from "react";

interface ContextValue {
  user?: User;
}

const Context = createContext<ContextValue>({});

export default Context
